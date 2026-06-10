//
//  WritingPracticeController.swift
//  KidX
//
//  Created by mt on 2026-06-10.
//

import UIKit

class WritingPracticeController: BaseController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet var digitButtons: [UIButton]!
    
    @IBOutlet weak var drawView: DrawView!
    
    @IBOutlet weak var resultContainerView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultMessageLabel: UILabel!
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var detectButton: UIButton!
    
    // MARK: - Properties
    private let viewModel: LearnViewModel
    private var selectedDigit: Int = 0
    
    init(viewModel: LearnViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        selectDigit(0)
    }
    
    override func setupUI() {
        setupLabels()
        setupButtons()
        setupResultContainer()
        setupDigitButtons()
    }
    
    private func setupLabels() {
        titleLabel.text = "Luyện viết chữ số"
        titleLabel.font = UIFont.custom(22, .semiBold)
        titleLabel.textColor = AppColor.text.color
        titleLabel.textAlignment = .center
        
        instructionLabel.font = UIFont.custom(16, .medium)
        instructionLabel.textColor = AppColor.text.color
        instructionLabel.textAlignment = .center
        
        resultMessageLabel.font = UIFont.custom(18, .semiBold)
        resultMessageLabel.textAlignment = .center
    }
    
    private func setupButtons() {
        // Back Button
        backButton.setTitle("", for: .normal)
        backButton.setImage(UIImage(resource: .icFlcBack), for: .normal)
        backButton.tintColor = AppColor.text.color
        
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        
        // Detect button (Magic Wand)
        detectButton.setTitle(" Kiểm tra", for: .normal)
        detectButton.setImage(UIImage(systemName: "wand.and.stars", withConfiguration: config), for: .normal)
        detectButton.tintColor = .white
        detectButton.backgroundColor = UIColor(hex: 0x2DCE89) // Green
        detectButton.setTitleColor(.white, for: .normal)
        detectButton.titleLabel?.font = UIFont.custom(16, .semiBold)
        detectButton.layer.cornerRadius = 26
        detectButton.layer.shadowColor = UIColor(hex: 0x2DCE89).cgColor
        detectButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        detectButton.layer.shadowOpacity = 0.3
        detectButton.layer.shadowRadius = 8
        
        // Clear button (Eraser)
        clearButton.setTitle(" Xóa vẽ", for: .normal)
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
    
    private func setupResultContainer() {
        resultContainerView.isHidden = true
        resultContainerView.alpha = 0
        resultContainerView.layer.cornerRadius = 16
        resultContainerView.backgroundColor = .white
        resultContainerView.layer.borderWidth = 1
        resultContainerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        
        resultLabel.font = UIFont.custom(64, .semiBold)
        resultLabel.textAlignment = .center
    }
    
    private func setupDigitButtons() {
        // Sort digit buttons by their tag (0 to 9) to ensure consistency
        digitButtons = digitButtons.sorted(by: { $0.tag < $1.tag })
        
        for button in digitButtons {
            button.layer.cornerRadius = 16
            button.titleLabel?.font = UIFont.custom(16, .semiBold)
            button.backgroundColor = .white
            button.setTitleColor(AppColor.text.color, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
            
            // Add shadow
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 0.05
            button.layer.shadowRadius = 4
        }
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        viewModel.onPredictionResult = { [weak self] digit in
            DispatchQueue.main.async {
                self?.handlePredictionResult(digit)
            }
        }
        viewModel.onError = { [weak self] _ in
            DispatchQueue.main.async {
                self?.handlePredictionResult("?")
            }
        }
        viewModel.onUnreliableResult = { [weak self] in
            DispatchQueue.main.async {
                self?.showUnreliableAlert()
            }
        }
    }
    
    // MARK: - Digit Selection
    private func selectDigit(_ digit: Int) {
        selectedDigit = digit
        instructionLabel.text = "Bé hãy viết số \(digit) lên bảng vẽ nhé!"
        
        // Update button states
        for button in digitButtons {
            if button.tag == digit {
                button.backgroundColor = AppColor.primary.color
                button.setTitleColor(.white, for: .normal)
                button.layer.borderColor = AppColor.primary.color.cgColor
            } else {
                button.backgroundColor = .white
                button.setTitleColor(AppColor.text.color, for: .normal)
                button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
            }
        }
        
        // Clear canvas
        clearCanvas()
    }
    
    private func clearCanvas() {
        drawView.clear()
        viewModel.reset()
        hideResult()
    }
    
    // MARK: - Handlers
    private func handlePredictionResult(_ digit: String) {
        resultLabel.text = digit
        
        let isCorrect = (digit == String(selectedDigit))
        if isCorrect {
            resultLabel.textColor = UIColor(hex: 0x27AE60) // Green
            resultMessageLabel.text = "Đúng rồi! Bé giỏi quá! 🎉"
            resultMessageLabel.textColor = UIColor(hex: 0x27AE60)
        } else {
            resultLabel.textColor = UIColor(hex: 0xEB5757) // Red
            resultMessageLabel.text = "Chưa đúng rồi, bé hãy viết lại nhé! 💪"
            resultMessageLabel.textColor = UIColor(hex: 0xEB5757)
        }
        
        resultContainerView.isHidden = false
        resultContainerView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.55,
            initialSpringVelocity: 0.8,
            options: .curveEaseOut
        ) {
            self.resultContainerView.alpha = 1
            self.resultContainerView.transform = .identity
        }
    }
    
    private func hideResult() {
        UIView.animate(withDuration: 0.2) {
            self.resultContainerView.alpha = 0
        } completion: { _ in
            self.resultContainerView.isHidden = true
        }
    }
    
    private func showUnreliableAlert() {
        let alert = UIAlertController(
            title: "Không nhận diện được",
            message: "Nét vẽ chưa rõ ràng, bé hãy vẽ lại nhé!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Vẽ lại", style: .default, handler: { [weak self] _ in
            self?.clearCanvas()
        }))
        alert.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        present(alert, animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func backTapped(_ sender: UIButton) {
        viewModel.navigateBack()
    }
    
    @IBAction func digitTapped(_ sender: UIButton) {
        selectDigit(sender.tag)
    }
    
    @IBAction func detectTapped(_ sender: UIButton) {
        guard !drawView.isEmpty else { return }
        guard let buffer = drawView.getPixelBuffer() else { return }
        viewModel.predict(from: buffer)
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        clearCanvas()
    }
}
