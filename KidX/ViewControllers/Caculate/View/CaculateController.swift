//
//  CaculateController.swift
//  KidX
//
//  Created by mitie on 11/6/26.
//

import UIKit

// MARK: - CaculateController
class CaculateController: BaseController {
    
    // MARK: - Outlets
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // Card Elements
    @IBOutlet private weak var cardContainerView: UIView!
    @IBOutlet private weak var todayChallengeLabel: UILabel!
    @IBOutlet private weak var levelLabel: UILabel!
    @IBOutlet private weak var equationLabel: UILabel!
    @IBOutlet private weak var dashedBox: DashedBorderView!
    @IBOutlet private weak var answerLabel: UILabel!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var difficultyLabel: UILabel!
    @IBOutlet private weak var timerLabel: UILabel!
    
    // Instruction Elements
    @IBOutlet private weak var writePromptLabel: UILabel!
    @IBOutlet private weak var writeHintLabel: UILabel!
    
    // Canvas Elements
    @IBOutlet private weak var canvasContainerView: UIView!
    @IBOutlet private weak var drawView: DrawView!
    @IBOutlet private weak var watermarkImageView: UIImageView!
    
    // Action Buttons
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var checkButton: UIButton!
    
    // MARK: - Properties
    private let viewModel: CaculateViewModel
    private var countdownTimer: Timer?
    private var timeRemaining: Int = 180
    
    // MARK: - Initialization
    init(viewModel: CaculateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CaculateController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.loadChallenges()
        
        if viewModel.difficulty == .advanced {
            startTimer()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Add card shadow path
        cardContainerView.layer.shadowPath = UIBezierPath(roundedRect: cardContainerView.bounds, cornerRadius: 24).cgPath
        
        // Dynamic shadow paths for styled buttons
        checkButton.layer.shadowPath = UIBezierPath(roundedRect: checkButton.bounds, cornerRadius: 26).cgPath
        clearButton.layer.shadowPath = UIBezierPath(roundedRect: clearButton.bounds, cornerRadius: 26).cgPath
    }
    
    // MARK: - Timer Logic
    private func startTimer() {
        countdownTimer?.invalidate()
        timeRemaining = 180
        updateTimerLabel()
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                self.updateTimerLabel()
                UserDefaults.standard.set(self.timeRemaining, forKey: "advanced_challenge_time_remaining")
            } else {
                self.handleTimeUp()
            }
        }
    }
    
    private func stopTimer() {
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
    
    private func updateTimerLabel() {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func handleTimeUp() {
        stopTimer()
        
        let alert = UIAlertController(
            title: "Time is up! ⏰".localize(),
            message: "Time is up! Let's try again!".localize(),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK".localize(), style: .default, handler: { [weak self] _ in
            self?.viewModel.navigateBack()
        }))
        present(alert, animated: true)
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        viewModel.onDataLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.updateChallengeUI()
            }
        }
        
        viewModel.onError = { [weak self] msg in
            DispatchQueue.main.async {
                self?.showAlert(title: "Notice".localize(), message: msg)
            }
        }
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        
        setupStyles()
        setupButtonActions()
        setupCanvasCallbacks()
    }
    
    private func setupStyles() {
        // Navigation Header Fonts & Tint
        titleLabel.font = UIFont.custom(22, .semiBold)
        titleLabel.textColor = AppColor.text.color
        
        difficultyLabel.font = UIFont.custom(11, .semiBold)
        difficultyLabel.textAlignment = .center
        difficultyLabel.textColor = .white
        difficultyLabel.layer.cornerRadius = 10
        difficultyLabel.clipsToBounds = true
        
        if viewModel.difficulty == .basic {
            titleLabel.text = "Phép Tính Vui Nhộn".localize()
            todayChallengeLabel.text = "PHÉP TÍNH CƠ BẢN".localize()
            difficultyLabel.text = "Cơ bản".localize().uppercased()
            difficultyLabel.backgroundColor = UIColor(hex: 0x007AFF) // Blue
            timerLabel.isHidden = true
        } else {
            titleLabel.text = "Thử Thách Hôm Nay".localize()
            todayChallengeLabel.text = "THỬ THÁCH HÔM NAY".localize()
            difficultyLabel.text = "Nâng cao".localize().uppercased()
            difficultyLabel.backgroundColor = UIColor(hex: 0xAF52DE) // Purple
            timerLabel.isHidden = false
        }
        
        backButton.setTitle("", for: .normal)
        backButton.setImage(UIImage(resource: .icFlcBack), for: .normal)
        backButton.tintColor = AppColor.text.color
        
        // Card Container Styling
        cardContainerView.backgroundColor = .white
        cardContainerView.layer.cornerRadius = 24
        cardContainerView.layer.shadowColor = UIColor(hex: 0x00264D).cgColor
        cardContainerView.layer.shadowOpacity = 0.05
        cardContainerView.layer.shadowRadius = 16
        cardContainerView.layer.shadowOffset = CGSize(width: 0, height: 8)
        
        todayChallengeLabel.font = UIFont.custom(14, .semiBold)
        todayChallengeLabel.textColor = AppColor.text.color.withAlphaComponent(0.6)
        
        levelLabel.font = UIFont.custom(14, .semiBold)
        levelLabel.textColor = AppColor.text.color
        
        equationLabel.font = UIFont.custom(64, .cherryBombRegular)
        equationLabel.textColor = AppColor.text.color
        equationLabel.textAlignment = .center
        
        answerLabel.font = UIFont.custom(64, .cherryBombRegular)
        answerLabel.textColor = AppColor.text.color
        answerLabel.textAlignment = .center
        
        // Next button inside Card
        nextButton.titleLabel?.font = UIFont.custom(16, .semiBold)
        nextButton.setTitleColor(AppColor.text.color, for: .normal)
        nextButton.backgroundColor = UIColor(hex: 0xF2F4F8)
        nextButton.layer.cornerRadius = 24
        nextButton.layer.shadowColor = UIColor.black.cgColor
        nextButton.layer.shadowOpacity = 0.06
        nextButton.layer.shadowRadius = 6
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        nextButton.alpha = 0
        nextButton.isHidden = true
        
        // Instructions Text Fonts
        writePromptLabel.font = UIFont.custom(16, .semiBold)
        writePromptLabel.textColor = AppColor.text.color
        
        writeHintLabel.font = UIFont.custom(12, .regular)
        writeHintLabel.textColor = AppColor.grey.color
        
        // Canvas Board styling
        canvasContainerView.backgroundColor = UIColor(hex: 0xEBEFF5)
        canvasContainerView.layer.cornerRadius = 20
        canvasContainerView.layer.borderWidth = 1
        canvasContainerView.layer.borderColor = UIColor(hex: 0xD0D7DE).withAlphaComponent(0.3).cgColor
        
        drawView.backgroundColor = .white
        drawView.strokeColor = AppColor.text.color
        drawView.lineWidth = 14
        drawView.layer.cornerRadius = 16
        drawView.layer.borderWidth = 0
        
        watermarkImageView.image = UIImage(systemName: "pencil")
        watermarkImageView.tintColor = UIColor(hex: 0xD0D7DE)
        watermarkImageView.contentMode = .scaleAspectFit
        watermarkImageView.alpha = 0.6
        watermarkImageView.isUserInteractionEnabled = false
        
        // Button Config to match WritingPracticeController
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        
        // Check Button (styled like detectButton in WritingPractice)
        let checkTitle = "Check".localize()
        checkButton.setTitle(" \(checkTitle)", for: .normal)
        checkButton.setImage(UIImage(systemName: "wand.and.stars", withConfiguration: config), for: .normal)
        checkButton.tintColor = .white
        checkButton.backgroundColor = UIColor(hex: 0x2DCE89) // Green
        checkButton.setTitleColor(.white, for: .normal)
        checkButton.titleLabel?.font = UIFont.custom(16, .semiBold)
        checkButton.layer.cornerRadius = 26
        checkButton.layer.shadowColor = UIColor(hex: 0x2DCE89).cgColor
        checkButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        checkButton.layer.shadowOpacity = 0.3
        checkButton.layer.shadowRadius = 8
        
        // Clear Button (styled like clearButton in WritingPractice)
        let clearTitle = "Clear".localize()
        clearButton.setTitle(" \(clearTitle)", for: .normal)
        clearButton.setImage(UIImage(systemName: "eraser.line.dashed", withConfiguration: config), for: .normal)
        clearButton.tintColor = .white
        clearButton.backgroundColor = UIColor(hex: 0xFF5B5C) // Soft red-orange
        clearButton.setTitleColor(.white, for: .normal)
        clearButton.titleLabel?.font = UIFont.custom(16, .semiBold)
        clearButton.layer.cornerRadius = 26
        clearButton.layer.shadowColor = UIColor(hex: 0xFF5B5C).cgColor
        clearButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        clearButton.layer.shadowOpacity = 0.3
        clearButton.layer.shadowRadius = 8
        clearButton.layer.borderWidth = 0
    }
    
    private func setupButtonActions() {
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(handleClear), for: .touchUpInside)
        checkButton.addTarget(self, action: #selector(handleCheck), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
    }
    
    private func setupCanvasCallbacks() {
        drawView.onDrawingBegan = { [weak self] in
            guard let self = self else { return }
            if self.watermarkImageView.alpha > 0 {
                UIView.animate(withDuration: 0.25) {
                    self.watermarkImageView.alpha = 0
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func handleBack() {
        viewModel.navigateBack()
    }
    
    @objc private func handleClear() {
        drawView.clear()
        UIView.animate(withDuration: 0.2) {
            self.watermarkImageView.alpha = 0.6
        }
    }
    
    @objc private func handleCheck() {
        guard !drawView.isEmpty else {
            showAlert(title: "Notice".localize(), message: "Please draw your answer before checking!".localize())
            return
        }
        
        guard let pixelBuffer = drawView.getPixelBuffer() else { return }
        
        Common.showMBHUDLoading()
        viewModel.checkAnswer(pixelBuffer: pixelBuffer) { [weak self] isCorrect, prediction in
            Common.hideMBHUDLoading()
            guard let self = self else { return }
            
            if isCorrect {
                self.showCorrectState(answer: prediction)
            } else {
                self.showIncorrectState(predictedAnswer: prediction)
            }
        }
    }
    
    @objc private func handleNext() {
        if viewModel.nextChallenge() {
            updateChallengeUI()
        } else {
            showGameCompletePopup()
        }
    }
    
    // MARK: - State Management
    private func updateChallengeUI() {
        guard let challenge = viewModel.currentChallenge else { return }
        
        levelLabel.text = String(format: "Cấp độ %d".localize(), challenge.level)
        equationLabel.text = "\(challenge.operand1) \(challenge.operation) \(challenge.operand2) ="
        
        // Reset answer block
        answerLabel.text = "?"
        answerLabel.textColor = AppColor.text.color
        
        // Hide next button
        nextButton.isHidden = true
        nextButton.alpha = 0
        
        // Reset canvas
        handleClear()
    }
    
    private func showCorrectState(answer: String) {
        answerLabel.text = answer
        answerLabel.textColor = UIColor(hex: 0x4CD964) // Bright green
        
        // Animation for showing the next level button
        nextButton.isHidden = false
        UIView.animate(withDuration: 0.35, delay: 0.1, options: .curveEaseOut, animations: {
            self.nextButton.alpha = 1
        })
    }
    
    private func showIncorrectState(predictedAnswer: String) {
        let originalColor = answerLabel.textColor
        answerLabel.text = predictedAnswer
        answerLabel.textColor = UIColor(hex: 0xFF3B30) // System red
        
        // Shake animation for the dashed box
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: dashedBox.center.x - 10, y: dashedBox.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: dashedBox.center.x + 10, y: dashedBox.center.y))
        
        dashedBox.layer.add(animation, forKey: "position")
        
        // Wait a second and restore the question mark so they can retry
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            guard let self = self else { return }
            self.answerLabel.text = "?"
            self.answerLabel.textColor = originalColor
            self.handleClear()
        }
    }
    
    private func showGameCompletePopup() {
        stopTimer()
        UserDefaults.standard.removeObject(forKey: "advanced_challenge_time_remaining")
        Common.triggerConfetti(in: self.view)
        
        let alert = UIAlertController(
            title: "Excellent! 🎉".localize(),
            message: "The child successfully completed all math challenges!".localize(),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Play again".localize(), style: .default, handler: { [weak self] _ in
            self?.viewModel.resetProgress()
        }))
        
        alert.addAction(UIAlertAction(title: "Close".localize(), style: .cancel, handler: { [weak self] _ in
            self?.viewModel.navigateBack()
        }))
        
        present(alert, animated: true)
    }
}
