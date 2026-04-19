//
//  RegisterController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 30/3/26.
//

import UIKit
import FirebaseAuth

class RegisterController: BaseController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnCreate: UIButton!

    private let viewModel: RegisterViewModel

    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        btnCreate.titleLabel?.font = UIFont.custom(20, .medium)
        btnLogin.titleLabel?.font = UIFont.custom(16, .semiBold)
        [emailTF, passwordTF, confirmPasswordTF].forEach {
            $0?.setHorizontalPadding(16)
        }
        containerView.layer.applyShadow(
            color: UIColor(hex: 0x2766B6),
            alpha: 0.1,
            size: CGSize(width: 0, height: -2),
            blur: 16,
            spread: 0,
            cornerRadius: 0
        )
        hideKeyboardWhenTappedAround()
    }

    // MARK: - Register
    private func performRegister() {
        let email = emailTF.text ?? ""
        let password = passwordTF.text ?? ""
        let confirmPassword = confirmPasswordTF.text ?? ""

        if let error = viewModel.validate(email: email, password: password, confirmPassword: confirmPassword) {
            showAlert(title: "Notice", message: error.message)
            return
        }

        Utils.showLoading()

        viewModel.register(email: email, password: password) { [weak self] result in
            guard let self else { return }
            Utils.hideLoading()

            switch result {
            case .success:
                self.showAlert(
                    title: "Account Created",
                    message: "Your account has been created successfully. Please check your inbox to verify your email.",
                    confirmHandler: {
                        self.viewModel.navigateBack()
                    }
                )
            case .failure(let error):
                self.showAlert(title: "Notice", message: error.message)
            }
        }
    }

    // MARK: - Helper
    private func toggleSecureEntry(for textField: UITextField, button: UIButton) {
        textField.isSecureTextEntry.toggle()
        let imageName = textField.isSecureTextEntry ? "ic-eye" : "ic-eye-slash"
        button.setImage(UIImage(named: imageName), for: .normal)
    }

    @IBAction func btnShowPasswordTapped(_ sender: UIButton) {
        toggleSecureEntry(for: passwordTF, button: sender)
    }

    @IBAction func btnShowConfirmPasswordTapped(_ sender: UIButton) {
        toggleSecureEntry(for: confirmPasswordTF, button: sender)
    }

    @IBAction func btnLoginTapped(_ sender: UIButton) {
        viewModel.navigateToLogin()
    }

    @IBAction func btnCreateTapped(_ sender: UIButton) {
        view.endEditing(true)
        performRegister()
    }

    @IBAction func btnBackTapped(_ sender: UIButton) {
        viewModel.navigateBack()
    }
}
