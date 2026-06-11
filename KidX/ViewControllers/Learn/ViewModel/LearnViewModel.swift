//
//  LearnViewModel.swift
//  KidX
//
//  ViewModel cho LearnController — xử lý toàn bộ logic nhận diện chữ số
//  thông qua mnistCNN CoreML model.
//

import CoreVideo
import Foundation

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
    private let predictor = MNISTDigitPredictor()
    private let navigation: NavigationState<MainRoute>

    init(navigation: NavigationState<MainRoute>) {
        self.navigation = navigation
    }

    // MARK: - Public API
    
    func navigateToWritingPractice() {
        navigation.push(.writingPractice(self))
    }
    
    func navigateToCaculate(difficulty: CaculateDifficulty = .basic) {
        navigation.push(.caculate(CaculateViewModel(navigation: navigation, difficulty: difficulty)))
    }
    
    func navigateBack() {
        navigation.pop()
    }

    /// Nhận diện chữ số từ CVPixelBuffer 28×28 grayscale
    func predict(from pixelBuffer: CVPixelBuffer) {
        do {
            let output = try predictor.predict(from: pixelBuffer)
            
            // Nếu độ tin cậy thấp (< 70%), coi như không nhận diện được
            if output.confidence < 0.7 {
                onUnreliableResult?()
            } else {
                lastPrediction = output.digit
                onPredictionResult?(output.digit)
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
