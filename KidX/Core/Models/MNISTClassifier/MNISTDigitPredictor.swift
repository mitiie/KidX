//
//  MNISTDigitPredictor.swift
//  KidX
//
//  Created by 𝙢𝙩 on 23/5/26.
//

import CoreML

final class MNISTDigitPredictor {
    struct Prediction {
        let digit: String
        let confidence: Double
    }

    private lazy var model: mnistCNN = {
        do {
            return try mnistCNN(configuration: MLModelConfiguration())
        } catch {
            fatalError("Khong the load mnistCNN model: \(error)")
        }
    }()

    func predict(from pixelBuffer: CVPixelBuffer) throws -> Prediction {
        let output = try model.prediction(image: pixelBuffer)
        let confidence = output.output[output.classLabel] ?? 0.0
        return Prediction(digit: output.classLabel, confidence: confidence)
    }
}
