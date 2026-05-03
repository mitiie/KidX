//
//  LoginController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 26/3/26.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class LoginController: BaseController {
    @IBOutlet weak var btnLoginGG: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPW: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        [emailTF, passwordTF].forEach { $0?.setHorizontalPadding(16) }
        btnLogin.titleLabel?.font = UIFont.custom(20, .medium)
        btnForgotPW.titleLabel?.font = UIFont.custom(16, .medium)
        btnRegister.titleLabel?.font = UIFont.custom(16, .semiBold)
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
    
    // MARK: - Email Login
    private func loginWithEmail() {
        let email = emailTF.text ?? ""
        let password = passwordTF.text ?? ""
        
        if let error = viewModel.validate(email: email, password: password) {
            showAlert(title: "Notice", message: error.message)
            return
        }
        
        Utils.showLoading()
        
        viewModel.loginWithEmail(email: email, password: password) { [weak self] result in
            guard let self else { return }
            Utils.hideLoading()
            
            switch result {
            case .success:
                self.viewModel.navigateToHome()
                
            case .failure(let error) where error == .emailNotVerified:
                self.showAlert(
                    title: "Email Not Verified",
                    message: error.message,
                    confirmTitle: "Resend Email",
                    confirmHandler: {
                        guard let user = Auth.auth().currentUser else { return }
                        self.resendVerification(user: user)
                    },
                    cancelTitle: "OK"
                )
                
            case .failure(let error):
                self.showAlert(title: "Notice", message: error.message)
            }
        }
    }
    
    // MARK: - Resend Verification
    private func resendVerification(user: User) {
        viewModel.resendVerificationEmail(user: user) { [weak self] error in
            guard let self else { return }
            if let error = error {
                print("❌ Resend verification failed: \(error.message)")
                self.showAlert(title: "Notice", message: error.message)
                return
            }
            print("✅ Verification email resent successfully")
            self.showAlert(title: "Email Sent", message: "Verification email has been resent. Please check your inbox.")
        }
    }
    
    // MARK: - Forgot Password
    private func sendPasswordReset() {
        let email = emailTF.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        guard !email.isEmpty, viewModel.isValidEmail(email) else {
            showAlert(
                title: "Forgot Password",
                message: "Please enter a valid email address in the email field to reset your password"
            )
            return
        }
        
        Utils.showLoading()
        
        viewModel.sendPasswordReset(email: email) { [weak self] error in
            guard let self else { return }
            Utils.hideLoading()
            
            if let error = error {
                self.showAlert(title: "Notice", message: error.message)
                return
            }
            self.showAlert(
                title: "Email Sent",
                message: "Password reset instructions have been sent to \(email). Please check your inbox."
            )
        }
    }
    
    // MARK: - Google Sign-In
    private func signInWithGoogle() {
        Utils.showLoading()
        
        viewModel.signInWithGoogle(presenting: self) { [weak self] result in
            guard let self else { return }
            Utils.hideLoading()
            
            switch result {
            case .success:
                self.viewModel.navigateToHome()
            case .failure(let error):
                self.showAlert(title: "Notice", message: error.message)
            }
        }
    }
    
    @IBAction func btnShowPasswordTapped(_ sender: UIButton) {
        passwordTF.isSecureTextEntry.toggle()
        let imageName = passwordTF.isSecureTextEntry ? "ic-eye" : "ic-eye-slash"
        sender.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func btnLoginGGTapped(_ sender: UIButton) {
        signInWithGoogle()
    }
    
    @IBAction func btnForgotPWTapped(_ sender: UIButton) {
        view.endEditing(true)
        sendPasswordReset()
    }
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        view.endEditing(true)
        loginWithEmail()
    }
    
    @IBAction func btnRegisterTapped(_ sender: UIButton) {
        viewModel.navigateToRegister()
    }
}
