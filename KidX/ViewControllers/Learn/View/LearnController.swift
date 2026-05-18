//
//  LearnController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 26/3/26.
//

import UIKit

class LearnController: BaseController {
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var resultContainerView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var detectButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - ViewModel
    private let viewModel: LearnViewModel

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
    }

    // MARK: - Setup UI (gọi bởi BaseController.viewDidLoad)
    override func setupUI() {
        setupLabels()
        setupButtons()
        setupResultContainer()
    }

    private func setupLabels() {
        titleLabel.text = "Luyện tập số"
        titleLabel.font = UIFont.custom(22, .semiBold)
        titleLabel.textColor = AppColor.text.color
        titleLabel.textAlignment = .center

        instructionLabel.text = "Vẽ một chữ số từ 0 đến 9"
        instructionLabel.font = UIFont.custom(14, .regular)
        instructionLabel.textColor = AppColor.grey.color
        instructionLabel.textAlignment = .center
    }

    private func setupButtons() {
        // Detect button
        detectButton.setTitle("Nhận diện", for: .normal)
        detectButton.backgroundColor = AppColor.primary.color
        detectButton.setTitleColor(.white, for: .normal)
        detectButton.titleLabel?.font = UIFont.custom(16, .semiBold)
        detectButton.layer.cornerRadius = 14

        // Clear button
        clearButton.setTitle("Xóa", for: .normal)
        clearButton.backgroundColor = .clear
        clearButton.setTitleColor(AppColor.primary.color, for: .normal)
        clearButton.titleLabel?.font = UIFont.custom(16, .semiBold)
        clearButton.layer.cornerRadius = 14
        clearButton.layer.borderWidth = 1.5
        clearButton.layer.borderColor = AppColor.primary.color.cgColor
    }

    private func setupResultContainer() {
        resultContainerView.isHidden = true
        resultContainerView.alpha = 0
        resultContainerView.layer.cornerRadius = 16
        resultLabel.font = UIFont.custom(72, .semiBold)
        resultLabel.textColor = AppColor.primary.color
        resultLabel.textAlignment = .center
    }

    // MARK: - Bindings
    private func setupBindings() {
        viewModel.onPredictionResult = { [weak self] digit in
            DispatchQueue.main.async {
                self?.showResult(digit)
            }
        }
        viewModel.onError = { [weak self] _ in
            DispatchQueue.main.async {
                self?.showResult("?")
            }
        }
        viewModel.onUnreliableResult = { [weak self] in
            DispatchQueue.main.async {
                self?.showUnreliableAlert()
            }
        }
    }


    // MARK: - IBActions
    @IBAction func detectTapped(_ sender: UIButton) {
        detect()
    }

    @IBAction func clearTapped(_ sender: UIButton) {
        drawView.clear()
        viewModel.reset()
        hideResult()
    }

    // MARK: - Private Helpers
    private func detect() {
        guard !drawView.isEmpty else { return }
        guard let buffer = drawView.getPixelBuffer() else { return }
        viewModel.predict(from: buffer)
    }

    private func showResult(_ digit: String) {
        resultLabel.text = digit
        resultContainerView.isHidden = false

        // Pop spring animation
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
            self?.clearTapped(UIButton())
        }))
        alert.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        present(alert, animated: true)
    }
}

