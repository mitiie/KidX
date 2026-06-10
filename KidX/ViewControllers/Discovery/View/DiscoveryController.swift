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
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private let viewModel: DiscoveryViewModel
    private let imagePredictor = ImagePredictor()
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    private var savedItems: [SavedObjectItem] = []
    
    // MARK: - Initializers
    init(viewModel: DiscoveryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadData()
        setupNotificationObserver()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(for: BannerCollectionViewCell.self)
        collectionView.registerNib(for: CollectionRowCollectionViewCell.self)
        collectionView.registerNib(for: GameCollectionViewCell.self)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 24
            layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 24, right: 0)
        }
    }
    
    private func loadData() {
        savedItems = SavedObjectsManager.shared.loadObjects()
        collectionView.reloadData()
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleReloadSavedObjects),
            name: NSNotification.Name("ReloadSavedObjects"),
            object: nil
        )
    }
    
    @objc private func handleReloadSavedObjects() {
        loadData()
    }
    
    // MARK: - Actions
    func startDetection() {
        viewModel.importPhoto(from: view, presenter: self, imagePickerDelegate: self, photoPickerDelegate: self)
    }

    // MARK: - UIImagePickerController & PHPicker Delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false)

        guard let originalImage = info[.originalImage] as? UIImage else { return }
        userSelectedPhoto(originalImage)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: false)

        guard let result = results.first else { return }

        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            if let error = error {
                print("Photo picker error: \(error)")
                return
            }

            guard let photo = object as? UIImage else { return }
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
                        self?.imagePredictionHandler(predictions, photo: photo)
                    }
                }
            } catch {
                print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
                DispatchQueue.main.async {
                    Common.hideLoading()
                    self?.showAlert(title: "Notice".localize(), message: "Unable to recognize this image.".localize())
                }
            }
        }
    }

    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?, photo: UIImage) {
        Common.hideLoading()

        guard let predictions = predictions, let bestPrediction = predictions.first else {
            showAlert(title: "Notice".localize(), message: "Not found".localize())
            return
        }

        let rawLabel = bestPrediction.classification
        let objectName: String
        let isVietnamese = LocalizeHelper.shared.isVietnameseSelected
        
        if isVietnamese {
            objectName = MobileNetLabelTranslator.vietnameseName(for: rawLabel).capitalized
        } else {
            var name = rawLabel
            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))
            }
            objectName = name.capitalized
        }

        let resultView = DetectResultView()
        
        resultView.onSaveTapped = { [weak self, weak resultView] in
            resultView?.dismiss()
            SavedObjectsManager.shared.save(image: photo, name: objectName)
            
            let title = "Success".localize()
            let message = String(format: "Saved \"%@\" to collection!".localize(), objectName)
            self?.showAlert(title: title, message: message)
        }
        
        resultView.onRetryTapped = { [weak self, weak resultView] in
            resultView?.dismiss()
            self?.startDetection()
        }
        
        resultView.onAudioTapped = { [weak self] in
            self?.speak(text: objectName)
        }

        let desc = "You just discovered a new object!".localize()
        resultView.show(
            on: self.view,
            objectName: objectName,
            description: desc,
            image: photo
        )
    }

    private func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: LocalizeHelper.shared.isVietnameseSelected ? "vi-VN" : "en-US")
        utterance.rate = 0.5
        speechSynthesizer.speak(utterance)
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension DiscoveryController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell: BannerCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.onStartTapped = { [weak self] in
                self?.startDetection()
            }
            return cell
            
        case 1:
            let cell: CollectionRowCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.items = savedItems
            cell.onViewAllTapped = { [weak self] in
                self?.showAlert(title: "Collection".localize(), message: "Under development!".localize())
            }
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: GameCollectionViewCell.self)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        switch indexPath.item {
        case 0:
            return CGSize(width: width, height: 150)
        case 1:
            return CGSize(width: width, height: 250)
        case 2:
            return CGSize(width: width, height: 230)
        default:
            return .zero
        }
    }
}
