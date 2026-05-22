//
//  ImagePredictor.swift
//  KidX
//
//  Created by 𝙢𝙩 on 23/5/26.
//

import CoreML
import UIKit
import Vision

final class ImagePredictor: @unchecked Sendable {
    nonisolated init() {}

    nonisolated static func createImageClassifier() -> VNCoreMLModel {
        let defaultConfig = MLModelConfiguration()
        let imageClassifierWrapper = try? MobileNet(configuration: defaultConfig)

        guard let imageClassifier = imageClassifierWrapper else {
            fatalError("App failed to create an image classifier model instance.")
        }

        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifier.model) else {
            fatalError("App failed to create a `VNCoreMLModel` instance.")
        }

        return imageClassifierVisionModel
    }

    nonisolated(unsafe) private static let imageClassifier = createImageClassifier()

    struct Prediction {
        let classification: String
        let confidencePercentage: String
    }

    typealias ImagePredictionHandler = (_ predictions: [Prediction]?) -> Void

    nonisolated(unsafe) private var predictionHandlers = [VNRequest: ImagePredictionHandler]()

    nonisolated private func createImageClassificationRequest() -> VNImageBasedRequest {
        let imageClassificationRequest = VNCoreMLRequest(
            model: ImagePredictor.imageClassifier,
            completionHandler: visionRequestHandler
        )
        imageClassificationRequest.imageCropAndScaleOption = .centerCrop
        return imageClassificationRequest
    }

    nonisolated func makePredictions(for photo: UIImage, completionHandler: @escaping ImagePredictionHandler) throws {
        let orientation = CGImagePropertyOrientation(photo.imageOrientation)

        guard let photoImage = photo.cgImage else {
            fatalError("Photo doesn't have underlying CGImage.")
        }

        let imageClassificationRequest = createImageClassificationRequest()
        predictionHandlers[imageClassificationRequest] = completionHandler

        let handler = VNImageRequestHandler(cgImage: photoImage, orientation: orientation)
        try handler.perform([imageClassificationRequest])
    }

    nonisolated private func visionRequestHandler(_ request: VNRequest, error: Error?) {
        guard let predictionHandler = predictionHandlers.removeValue(forKey: request) else {
            fatalError("Every request must have a prediction handler.")
        }

        var predictions: [Prediction]?

        defer {
            predictionHandler(predictions)
        }

        if let error = error {
            print("Vision image classification error...\n\n\(error.localizedDescription)")
            return
        }

        guard let observations = request.results as? [VNClassificationObservation] else {
            print("VNRequest produced the wrong result type: \(type(of: request.results)).")
            return
        }

        predictions = observations.map { observation in
            Prediction(
                classification: observation.identifier,
                confidencePercentage: observation.confidencePercentageString
            )
        }
    }
}
