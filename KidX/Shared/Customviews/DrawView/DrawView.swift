//
//  DrawView.swift
//  KidX
//
//  Custom UIView cho phép người dùng vẽ bằng ngón tay.
//  Xuất CVPixelBuffer 28×28 grayscale dùng làm input cho mnistCNN.
//

import UIKit

// MARK: - Line Model
/// Lưu một đoạn thẳng (2 điểm liên tiếp khi người dùng vuốt)
struct Line {
    var start: CGPoint
    var end: CGPoint
}

// MARK: - DrawView
class DrawView: UIView {

    // MARK: - Config
    /// Độ dày nét vẽ — 20pt tối ưu cho canvas chuẩn MNIST sau khi scale
    var lineWidth: CGFloat = 20 { didSet { setNeedsDisplay() } }
    /// Màu nét — phải là trắng (chuẩn MNIST: trắng trên đen)
    var strokeColor: UIColor = .white { didSet { setNeedsDisplay() } }

    // MARK: - State
    private(set) var lines: [Line] = []
    private var lastPoint: CGPoint?

    /// Callback — được gọi ngay khi người dùng nhấc tay lên (touchesEnded)
    var onDrawingEnded: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .black
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
        clipsToBounds = true
    }

    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastPoint = touches.first?.location(in: self)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let newPoint = touches.first?.location(in: self),
              let start = lastPoint else { return }
        lines.append(Line(start: start, end: newPoint))
        lastPoint = newPoint
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastPoint = nil
        onDrawingEnded?()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastPoint = nil
    }

    // MARK: - Rendering
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath()
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        for line in lines {
            path.move(to: line.start)
            path.addLine(to: line.end)
        }
        path.lineWidth = lineWidth
        strokeColor.setStroke()
        path.stroke()
    }

    // MARK: - Public API
    /// True nếu chưa có nét vẽ nào
    var isEmpty: Bool { lines.isEmpty }

    /// Xóa toàn bộ nét vẽ
    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }

    /// Xuất canvas thành CVPixelBuffer 28×28 grayscale — input chuẩn cho mnistCNN
    func getPixelBuffer() -> CVPixelBuffer? {
        guard !lines.isEmpty else { return nil }

        // 1. Tìm bounding box của nét vẽ để căn giữa
        var minX = CGFloat.greatestFiniteMagnitude
        var minY = CGFloat.greatestFiniteMagnitude
        var maxX = CGFloat.leastNormalMagnitude
        var maxY = CGFloat.leastNormalMagnitude

        for line in lines {
            minX = min(minX, line.start.x, line.end.x)
            minY = min(minY, line.start.y, line.end.y)
            maxX = max(maxX, line.start.x, line.end.x)
            maxY = max(maxY, line.start.y, line.end.y)
        }

        // Thêm padding cho bounding box dựa trên lineWidth
        let drawingRect = CGRect(x: minX - lineWidth/2,
                                 y: minY - lineWidth/2,
                                 width: (maxX - minX) + lineWidth,
                                 height: (maxY - minY) + lineWidth)

        // 2. Tạo CGContext 28×28 grayscale
        let colorSpace = CGColorSpaceCreateDeviceGray()
        guard let context = CGContext(
            data: nil,
            width: 28,
            height: 28,
            bitsPerComponent: 8,
            bytesPerRow: 28,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.none.rawValue
        ) else { return nil }

        // Tô đen background
        context.setFillColor(UIColor.black.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: 28, height: 28))

        // Tính toán scale để fit vào vùng 20x20 (để có padding 4px mỗi bên)
        let targetSize: CGFloat = 20
        let scale = min(targetSize / drawingRect.width, targetSize / drawingRect.height)
        let scaledWidth = drawingRect.width * scale
        let scaledHeight = drawingRect.height * scale

        // Căn giữa
        let offsetX = (28 - scaledWidth) / 2
        let offsetY = (28 - scaledHeight) / 2

        context.saveGState()
        context.translateBy(x: offsetX, y: offsetY + scaledHeight)
        context.scaleBy(x: scale, y: -scale)
        context.translateBy(x: -drawingRect.origin.x, y: -drawingRect.origin.y)

        layer.render(in: context)
        context.restoreGState()

        // 3. CGContext → CGImage → CIImage
        guard let cgImage = context.makeImage() else { return nil }
        let ciImage = CIImage(cgImage: cgImage)

        // 3. Tạo CVPixelBuffer OneComponent8 (1 kênh grayscale, không alpha)
        var pixelBuffer: CVPixelBuffer?
        let attrs: CFDictionary = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ] as CFDictionary
        CVPixelBufferCreate(kCFAllocatorDefault, 28, 28,
                            kCVPixelFormatType_OneComponent8,
                            attrs, &pixelBuffer)

        guard let buffer = pixelBuffer else { return nil }
        CIContext().render(ciImage, to: buffer)
        return buffer
    }
}
