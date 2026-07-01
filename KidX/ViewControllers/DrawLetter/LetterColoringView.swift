//
//  LetterColoringView.swift
//  KidX
//
//  Created by mt on 14/6/26.
//

import CoreText
import UIKit

private struct LetterStroke {
    let points: [CGPoint]
    let color: UIColor
    let width: CGFloat
}

final class LetterColoringView: UIView {
    var letter: AlphabetLetter? {
        didSet {
            clear()
            setNeedsDisplay()
        }
    }

    var isUppercase = true {
        didSet {
            clear()
            setNeedsDisplay()
        }
    }

    var drawingColor = UIColor(hex: 0xF8A23A)
    var drawingWidth: CGFloat = 52

    private var strokes: [LetterStroke] = []
    private var currentPoints: [CGPoint] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func clear() {
        strokes.removeAll()
        currentPoints.removeAll()
        setNeedsDisplay()
    }

    private func setup() {
        backgroundColor = .clear
        contentMode = .redraw
        isMultipleTouchEnabled = false
        clipsToBounds = true
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let letter else { return }

        drawHeader(for: letter)

        let text = isUppercase ? letter.uppercase : letter.lowercase
        let templateRect = CGRect(
            x: bounds.width * 0.18,
            y: bounds.height * 0.25,
            width: bounds.width * 0.64,
            height: bounds.height * 0.50
        )

        let letterPath = makeLetterPath(text: text, in: templateRect)
        let guidePath = scaledPath(letterPath, scale: isUppercase ? 1.16 : 1.08)

        drawGuidePath(guidePath)
        UIColor.white.setFill()
        letterPath.fill()

        drawStrokes(clippedTo: letterPath)
        UIColor.black.setStroke()
        letterPath.lineWidth = 7
        letterPath.lineJoinStyle = .round
        letterPath.stroke()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        currentPoints = [point]
        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        currentPoints.append(point)
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        finishCurrentStroke()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        finishCurrentStroke()
    }

    private func finishCurrentStroke() {
        guard currentPoints.count > 1 else {
            currentPoints.removeAll()
            return
        }

        strokes.append(LetterStroke(points: currentPoints, color: drawingColor, width: drawingWidth))
        currentPoints.removeAll()
        setNeedsDisplay()
    }

    private func drawHeader(for letter: AlphabetLetter) {
        let display = letter.displayText
        let centerAttributes = letterAttributes(
            fontSize: 56,
            fillColor: UIColor(hex: letter.primaryHex),
            strokeColor: UIColor(hex: 0x8C496D),
            strokeWidth: -4
        )
        let rightAttributes = letterAttributes(
            fontSize: 32,
            fillColor: UIColor(hex: 0xFFA33B),
            strokeColor: UIColor.white,
            strokeWidth: -2
        )

        let title = NSAttributedString(string: display, attributes: centerAttributes)
        title.draw(at: CGPoint(x: (bounds.width - title.size().width) / 2, y: 58))

        let miniTitle = NSAttributedString(string: display, attributes: rightAttributes)
        miniTitle.draw(at: CGPoint(x: bounds.width - miniTitle.size().width - 26, y: 98))
    }

    private func letterAttributes(fontSize: CGFloat, fillColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat) -> [NSAttributedString.Key: Any] {
        [
            .font: UIFont.custom(fontSize, .cherryBombRegular),
            .foregroundColor: fillColor,
            .strokeColor: strokeColor,
            .strokeWidth: strokeWidth
        ]
    }

    private func drawGuidePath(_ path: UIBezierPath) {
        UIColor.black.setStroke()
        path.lineWidth = 4
        path.lineJoinStyle = .round
        path.lineCapStyle = .butt
        path.setLineDash([16, 15], count: 2, phase: 0)
        path.stroke()
    }

    private func drawStrokes(clippedTo letterPath: UIBezierPath) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        letterPath.addClip()
        strokes.forEach(drawStroke)
        if currentPoints.count > 1 {
            drawStroke(LetterStroke(points: currentPoints, color: drawingColor, width: drawingWidth))
        }
        context.restoreGState()
    }

    private func drawStroke(_ stroke: LetterStroke) {
        drawPath(points: stroke.points, color: stroke.color, width: stroke.width * 0.92, alpha: 0.46, offset: .zero)
        drawCrayonStrands(for: stroke)
        drawCrayonParticles(for: stroke)
    }

    private func drawPath(points: [CGPoint], color: UIColor, width: CGFloat, alpha: CGFloat, offset: CGPoint) {
        guard points.count > 1 else { return }

        let path = makeSmoothPath(points: points, offset: offset)
        path.lineWidth = width
        color.withAlphaComponent(alpha).setStroke()
        path.stroke()
    }

    private func drawCrayonStrands(for stroke: LetterStroke) {
        for index in 0..<18 {
            let angle = randomUnit(seed: index * 17) * .pi * 2
            let distance = (randomUnit(seed: index * 31) - 0.5) * stroke.width * 0.42
            let offset = CGPoint(x: cos(angle) * distance, y: sin(angle) * distance)
            let width = CGFloat(2.2 + randomUnit(seed: index * 47) * 4.8)
            let alpha = CGFloat(0.12 + randomUnit(seed: index * 59) * 0.20)
            drawPath(points: stroke.points, color: stroke.color, width: width, alpha: alpha, offset: offset)
        }
    }

    private func drawCrayonParticles(for stroke: LetterStroke) {
        guard stroke.points.count > 1 else { return }

        let step = max(1, stroke.points.count / 90)
        var sampleIndex = 0

        for pointIndex in stride(from: 0, to: stroke.points.count, by: step) {
            let point = stroke.points[pointIndex]
            drawParticles(
                around: point,
                strokeWidth: stroke.width,
                color: stroke.color,
                seedBase: sampleIndex * 97,
                isHighlight: false
            )
            drawParticles(
                around: point,
                strokeWidth: stroke.width,
                color: .white,
                seedBase: sampleIndex * 131,
                isHighlight: true
            )
            sampleIndex += 1
        }
    }

    private func drawParticles(around point: CGPoint, strokeWidth: CGFloat, color: UIColor, seedBase: Int, isHighlight: Bool) {
        let count = isHighlight ? 5 : 8
        let radiusMultiplier: CGFloat = isHighlight ? 0.42 : 0.50

        for index in 0..<count {
            let angle = randomUnit(seed: seedBase + index * 11) * .pi * 2
            let distance = pow(randomUnit(seed: seedBase + index * 13), 0.72) * strokeWidth * radiusMultiplier
            let center = CGPoint(
                x: point.x + cos(angle) * distance,
                y: point.y + sin(angle) * distance
            )
            let size = CGFloat((isHighlight ? 1.2 : 1.6) + randomUnit(seed: seedBase + index * 17) * (isHighlight ? 3.0 : 4.2))
            let alpha = CGFloat((isHighlight ? 0.40 : 0.24) + randomUnit(seed: seedBase + index * 19) * (isHighlight ? 0.32 : 0.30))
            let rect = CGRect(x: center.x - size / 2, y: center.y - size / 2, width: size, height: size)
            color.withAlphaComponent(alpha).setFill()
            UIBezierPath(ovalIn: rect).fill()
        }
    }

    private func makeSmoothPath(points: [CGPoint], offset: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.move(to: CGPoint(x: points[0].x + offset.x, y: points[0].y + offset.y))

        guard points.count > 2 else {
            path.addLine(to: CGPoint(x: points[1].x + offset.x, y: points[1].y + offset.y))
            return path
        }

        for index in 1..<(points.count - 1) {
            let current = points[index]
            let next = points[index + 1]
            let midPoint = CGPoint(
                x: (current.x + next.x) / 2 + offset.x,
                y: (current.y + next.y) / 2 + offset.y
            )
            path.addQuadCurve(
                to: midPoint,
                controlPoint: CGPoint(x: current.x + offset.x, y: current.y + offset.y)
            )
        }

        if let last = points.last {
            path.addLine(to: CGPoint(x: last.x + offset.x, y: last.y + offset.y))
        }

        return path
    }

    private func randomUnit(seed: Int) -> CGFloat {
        var value = UInt64(bitPattern: Int64(seed))
        value &+= 0x9E3779B97F4A7C15
        value = (value ^ (value >> 30)) &* 0xBF58476D1CE4E5B9
        value = (value ^ (value >> 27)) &* 0x94D049BB133111EB
        value = value ^ (value >> 31)
        return CGFloat(value & 0xFFFF) / CGFloat(0xFFFF)
    }

    private func makeLetterPath(text: String, in rect: CGRect) -> UIBezierPath {
        let font = UIFont.custom(340, .cherryBombRegular)
        let ctFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        let characters = Array(text.utf16)
        var glyphs = Array(repeating: CGGlyph(), count: characters.count)
        CTFontGetGlyphsForCharacters(ctFont, characters, &glyphs, characters.count)

        let combinedPath = CGMutablePath()
        var xOffset: CGFloat = 0
        for glyph in glyphs {
            guard let glyphPath = CTFontCreatePathForGlyph(ctFont, glyph, nil) else { continue }
            let transform = CGAffineTransform(translationX: xOffset, y: 0).scaledBy(x: 1, y: -1)
            combinedPath.addPath(glyphPath, transform: transform)
            var advance = CGSize.zero
            CTFontGetAdvancesForGlyphs(ctFont, .horizontal, [glyph], &advance, 1)
            xOffset += advance.width
        }

        let path = UIBezierPath(cgPath: combinedPath)
        let bounds = path.bounds
        guard bounds.width > 0, bounds.height > 0 else { return path }

        let scale = min(rect.width / bounds.width, rect.height / bounds.height)
        path.apply(CGAffineTransform(scaleX: scale, y: scale))

        let scaledBounds = path.bounds
        path.apply(CGAffineTransform(
            translationX: rect.midX - scaledBounds.midX,
            y: rect.midY - scaledBounds.midY
        ))

        return path
    }

    private func scaledPath(_ path: UIBezierPath, scale: CGFloat) -> UIBezierPath {
        let copy = UIBezierPath(cgPath: path.cgPath)
        let center = CGPoint(x: path.bounds.midX, y: path.bounds.midY)
        copy.apply(CGAffineTransform(translationX: -center.x, y: -center.y))
        copy.apply(CGAffineTransform(scaleX: scale, y: scale))
        copy.apply(CGAffineTransform(translationX: center.x, y: center.y))
        return copy
    }
}
