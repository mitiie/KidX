//
//  MNISTPixelBufferFactory.swift
//  KidX
//
//  Created by 𝙢𝙩 on 23/5/26.
//

import CoreImage
import UIKit

enum MNISTPixelBufferFactory {
    static func makePixelBuffer(from layer: CALayer,
                                drawingRect: CGRect,
                                lineWidth: CGFloat) -> CVPixelBuffer? {
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

        context.setFillColor(UIColor.black.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: 28, height: 28))

        let expandedDrawingRect = CGRect(
            x: drawingRect.minX - lineWidth / 2,
            y: drawingRect.minY - lineWidth / 2,
            width: drawingRect.width + lineWidth,
            height: drawingRect.height + lineWidth
        )

        let targetSize: CGFloat = 20
        let scale = min(targetSize / expandedDrawingRect.width, targetSize / expandedDrawingRect.height)
        let scaledWidth = expandedDrawingRect.width * scale
        let scaledHeight = expandedDrawingRect.height * scale
        let offsetX = (28 - scaledWidth) / 2
        let offsetY = (28 - scaledHeight) / 2

        context.saveGState()
        context.translateBy(x: offsetX, y: offsetY + scaledHeight)
        context.scaleBy(x: scale, y: -scale)
        context.translateBy(x: -expandedDrawingRect.origin.x, y: -expandedDrawingRect.origin.y)
        layer.render(in: context)
        context.restoreGState()

        guard let cgImage = context.makeImage() else { return nil }
        let ciImage = CIImage(cgImage: cgImage)

        var pixelBuffer: CVPixelBuffer?
        let attrs: CFDictionary = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ] as CFDictionary

        CVPixelBufferCreate(
            kCFAllocatorDefault,
            28,
            28,
            kCVPixelFormatType_OneComponent8,
            attrs,
            &pixelBuffer
        )

        guard let buffer = pixelBuffer else { return nil }
        CIContext().render(ciImage, to: buffer)
        return buffer
    }
}
