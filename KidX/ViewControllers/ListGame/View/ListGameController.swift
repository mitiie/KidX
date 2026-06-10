//
//  ListGameController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 11/6/26.
//

import AVFoundation
import FirebaseDatabase
import PhotosUI
import UIKit

class ListGameController: BaseController, XibLoadable, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var backButton: UIButton!
    
    // MARK: - Properties
    private let viewModel: ListGameViewModel
    private let imagePredictor = ImagePredictor()
    
    private var missions: [MissionData] = []
    private var activeMissionIndex: Int?
    private var capturedImage: UIImage?
    
    // MARK: - Initialization
    init(viewModel: ListGameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: Self.xibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    // MARK: - Load Data
    private func loadData() {
        Common.showLoading()
        
        let ref = Database.database().reference().child("missions")
        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            Common.hideLoading()
            guard let self = self else { return }
            
            guard let rawValue = snapshot.value else {
                print("Firebase snapshot has no value.")
                return
            }
            
            var missionsList: [[String: Any]] = []
            
            if let dict = rawValue as? [String: [String: Any]] {
                missionsList = Array(dict.values)
            } else if let array = rawValue as? [[String: Any]] {
                missionsList = array
            } else if let array = rawValue as? [Any] {
                missionsList = array.compactMap { $0 as? [String: Any] }
            } else if let dict = rawValue as? [String: Any] {
                missionsList = dict.values.compactMap { $0 as? [String: Any] }
            }
            
            guard !missionsList.isEmpty else {
                print("No missions found in Firebase database or wrong format. Raw value: \(rawValue)")
                return
            }
            
            do {
                let completedIds = MissionData.getCompletedMissionIds()
                let jsonData = try JSONSerialization.data(withJSONObject: missionsList, options: [])
                var decodedMissions = try JSONDecoder().decode([MissionData].self, from: jsonData)
                
                // Sort by ID to keep consistent order
                decodedMissions.sort { $0.id < $1.id }
                
                // Set completion status based on local UserDefaults
                self.missions = decodedMissions.map { mission in
                    var m = mission
                    m.isCompleted = completedIds.contains(m.id)
                    return m
                }
                
                self.tableView.reloadData()
                
                // Post notification to reload DiscoveryController
                NotificationCenter.default.post(name: NSNotification.Name("ReloadSavedObjects"), object: nil)
                
            } catch {
                print("Failed to decode missions from Firebase: \(error)")
            }
        } withCancel: { error in
            Common.hideLoading()
            print("Failed to fetch Firebase database: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNib(for: MissionBannerTableCell.self)
        tableView.registerNib(for: MissionTableCell.self)
        
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Gameplay/Camera Logic
    private func startMissionDetection(at index: Int) {
        self.activeMissionIndex = index
        viewModel.importPhoto(from: self.view, presenter: self, imagePickerDelegate: self, photoPickerDelegate: self)
    }
    
    // MARK: - Picker Delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false)
        guard let originalImage = info[.originalImage] as? UIImage else { return }
        self.capturedImage = originalImage
        evaluatePrediction(for: originalImage)
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
                self?.capturedImage = photo
                self?.evaluatePrediction(for: photo)
            }
        }
    }
    
    private func evaluatePrediction(for photo: UIImage) {
        guard let activeIndex = activeMissionIndex, activeIndex < missions.count else { return }
        let mission = missions[activeIndex]
        
        Common.showLoading()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                try self?.imagePredictor.makePredictions(for: photo) { [weak self] predictions in
                    DispatchQueue.main.async {
                        Common.hideLoading()
                        self?.handlePredictions(predictions, for: mission)
                    }
                }
            } catch {
                print("Failed to run prediction: \(error)")
                DispatchQueue.main.async {
                    Common.hideLoading()
                    self?.showAlert(title: "Notice".localize(), message: "Unable to recognize this image.".localize())
                }
            }
        }
    }
    
    private func handlePredictions(_ predictions: [ImagePredictor.Prediction]?, for mission: MissionData) {
        guard let predictions = predictions, let bestPrediction = predictions.first else {
            showAlert(title: "Notice".localize(), message: "Not found".localize())
            return
        }
        
        let detectedRawLabel = bestPrediction.classification.lowercased()
        
        // Check if any keyword matches the detected text
        let isMatched = mission.keywords.contains { keyword in
            detectedRawLabel.contains(keyword.lowercased())
        }
        
        if isMatched {
            // Success! Save progress
            MissionData.setMissionCompleted(id: mission.id)
            
            // Translate object name for saving
            let translatedName: String
            if LocalizeHelper.shared.isVietnameseSelected {
                translatedName = MobileNetLabelTranslator.vietnameseName(for: bestPrediction.classification).capitalized
            } else {
                var name = bestPrediction.classification
                if let firstComma = name.firstIndex(of: ",") {
                    name = String(name.prefix(upTo: firstComma))
                }
                translatedName = name.capitalized
            }
            
            // Save to the main collection
            if let image = self.capturedImage {
                SavedObjectsManager.shared.save(image: image, name: translatedName)
            }
            
            showSuccessPopup(for: mission)
        } else {
            // Failed match
            let detectedName: String
            if LocalizeHelper.shared.isVietnameseSelected {
                detectedName = MobileNetLabelTranslator.vietnameseName(for: bestPrediction.classification)
            } else {
                var name = bestPrediction.classification
                if let firstComma = name.firstIndex(of: ",") {
                    name = String(name.prefix(upTo: firstComma))
                }
                detectedName = name
            }
            showFailurePopup(detected: detectedName)
        }
    }
    
    private func showSuccessPopup(for mission: MissionData) {
        let msg = String(format: "Congratulations! You found the %@!".localize(), mission.title)
        
        let resultView = DetectResultView(frame: self.view.bounds)
        resultView.showForMission(
            on: self.view,
            isSuccess: true,
            message: msg,
            image: self.capturedImage,
            onRetry: nil
        ) { [weak self] in
            self?.loadData()
        }
    }
    
    private func showFailurePopup(detected: String) {
        let msg = String(format: "Oops! This looks like %@. Try again!".localize(), detected)
        
        let resultView = DetectResultView(frame: self.view.bounds)
        resultView.showForMission(
            on: self.view,
            isSuccess: false,
            message: msg,
            image: self.capturedImage,
            onRetry: { [weak self] in
                guard let activeIndex = self?.activeMissionIndex else { return }
                self?.startMissionDetection(at: activeIndex)
            },
            onDismiss: nil
        )
    }
}

// MARK: - UITableView Delegate & DataSource
extension ListGameController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + missions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MissionBannerTableCell.self)
            let completedCount = missions.filter { $0.isCompleted }.count
            let totalCount = missions.count
            cell.configData(completedCount: completedCount, totalCount: totalCount)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MissionTableCell.self)
            let mission = missions[indexPath.row - 1]
            
            cell.configData(with: mission) { [weak self] in
                self?.startMissionDetection(at: indexPath.row - 1)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
