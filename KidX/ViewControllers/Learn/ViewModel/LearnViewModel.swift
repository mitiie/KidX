//
//  LearnViewModel.swift
//  KidX
//
//  ViewModel cho LearnController — xử lý toàn bộ logic nhận diện chữ số
//  thông qua mnistCNN CoreML model.
//

import CoreML

class LearnViewModel {

    // MARK: - Output Callbacks
    /// Được gọi khi có kết quả nhận diện thành công
    var onPredictionResult: ((String) -> Void)?
    /// Được gọi khi xảy ra lỗi
    var onError: ((String) -> Void)?
    /// Được gọi khi kết quả nhận diện không đủ tin cậy
    var onUnreliableResult: (() -> Void)?

    // MARK: - State
    private(set) var lastPrediction: String = ""

    // MARK: - CoreML Model (lazy — chỉ tạo khi cần lần đầu)
    private lazy var model: mnistCNN = {
        do {
            return try mnistCNN(configuration: MLModelConfiguration())
        } catch {
            fatalError("Không thể load mnistCNN model: \(error)")
        }
    }()

    // MARK: - Public API

    /// Nhận diện chữ số từ CVPixelBuffer 28×28 grayscale
    func predict(from pixelBuffer: CVPixelBuffer) {
        do {
            let output = try model.prediction(image: pixelBuffer)
            let confidence = output.output[output.classLabel] ?? 0.0
            
            // Nếu độ tin cậy thấp (< 70%), coi như không nhận diện được
            if confidence < 0.7 {
                onUnreliableResult?()
            } else {
                lastPrediction = output.classLabel
                onPredictionResult?(output.classLabel)
            }
        } catch {
            onError?("Lỗi nhận diện: \(error.localizedDescription)")
        }
    }

    /// Reset state (dùng khi user xóa canvas)
    func reset() {
        lastPrediction = ""
    }
}
