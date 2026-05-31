//
//  DiscoveryController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 26/3/26.
//

import AVFoundation
import PhotosUI
import UIKit

class DiscoveryController: BaseController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    private let viewModel: DiscoveryViewModel
    private let imagePredictor = ImagePredictor()
    private let predictionsToShow = 2
    private let speechSynthesizer = AVSpeechSynthesizer()

    init(viewModel: DiscoveryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btnAddNewTapped(_ sender: Any) {
        viewModel.importPhoto(from: view, presenter: self, imagePickerDelegate: self, photoPickerDelegate: self)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false)

        guard let originalImage = info[.originalImage] else {
            fatalError("Picker didn't have an original image.")
        }

        guard let photo = originalImage as? UIImage else {
            fatalError("The Camera Image Picker's image isn't a/n \(UIImage.self) instance.")
        }

        userSelectedPhoto(photo)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: false)

        guard let result = results.first else { return }

        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            if let error = error {
                print("Photo picker error: \(error)")
                return
            }

            guard let photo = object as? UIImage else {
                fatalError("The Photo Picker's image isn't a/n \(UIImage.self) instance.")
            }

            DispatchQueue.main.async {
                self?.userSelectedPhoto(photo)
            }
        }
    }

    private func userSelectedPhoto(_ photo: UIImage) {
        Common.showLoading()
        let imagePredictor = imagePredictor

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                try imagePredictor.makePredictions(for: photo) { [weak self] predictions in
                    DispatchQueue.main.async {
                        self?.imagePredictionHandler(predictions)
                    }
                }
            } catch {
                print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
                DispatchQueue.main.async {
                    Common.hideLoading()
                    self?.showAlert(title: "Notice", message: "Unable to recognize this image.")
                }
            }
        }
    }

    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
        Common.hideLoading()

        guard let predictions = predictions else {
            showAlert(title: "Notice", message: "No predictions. Check console log.")
            return
        }

        guard let bestPrediction = predictions.first else {
            showAlert(title: "Notice", message: "No predictions found.")
            return
        }

        var name = bestPrediction.classification
        if let firstComma = name.firstIndex(of: ",") {
            name = String(name.prefix(upTo: firstComma))
        }
        let objectName = name.capitalized

        let resultView = DetectResultView()
        
        resultView.onSaveTapped = { [weak self, weak resultView] in
            resultView?.dismiss()
            self?.showAlert(title: "Thành công", message: "Đã lưu \"\(objectName)\" vào bộ sưu tập!")
        }
        
        resultView.onRetryTapped = { [weak self, weak resultView] in
            resultView?.dismiss()
            if let self = self {
                self.btnAddNewTapped(self)
            }
        }
        
        resultView.onAudioTapped = { [weak self] in
            self?.speak(text: objectName)
        }

        resultView.show(
            on: self.view,
            objectName: objectName,
            description: "Bạn vừa khám phá ra một đồ vật mới!"
        )
    }

    private func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        speechSynthesizer.speak(utterance)
    }

    private func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [String] {
        return predictions.prefix(predictionsToShow).map { prediction in
            var name = prediction.classification

            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))
            }

            return "\(name) - \(prediction.confidencePercentage)%"
        }
    }
}
