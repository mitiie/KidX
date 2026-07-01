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
    /// Callback — được gọi khi người dùng bắt đầu chạm vẽ (touchesBegan)
    var onDrawingBegan: (() -> Void)?

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
        onDrawingBegan?()
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

        let originalBG = backgroundColor
        let originalStroke = strokeColor
        let originalBorderColor = layer.borderColor
        
        // Temporarily set to black background and white strokes for MNIST rendering
        backgroundColor = .black
        strokeColor = .white
        layer.borderColor = UIColor.black.cgColor
        
        // Force display update
        setNeedsDisplay()

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

        let drawingRect = CGRect(x: minX,
                                 y: minY,
                                 width: maxX - minX,
                                 height: maxY - minY)
        let buffer = MNISTPixelBufferFactory.makePixelBuffer(from: layer, drawingRect: drawingRect, lineWidth: lineWidth)
        
        // Restore original visual styles
        backgroundColor = originalBG
        strokeColor = originalStroke
        layer.borderColor = originalBorderColor
        setNeedsDisplay()
        
        return buffer
    }
}
