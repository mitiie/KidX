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
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btnLoginGGTapped(_ sender: UIButton) {
        signInWithGoogle()
    }
    
    // MARK: - Google Sign-In
    private func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            if let error = error {
                print("Lỗi Google Sign-In: \(error.localizedDescription)")
                return
            }

            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString
            else { return }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            // Đăng nhập Firebase
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    print("Lỗi Firebase Auth: \(error.localizedDescription)")
                    return
                }
                // Thành công → vào Home
                self?.navigateToHome()
            }
        }
    }

    // MARK: - Navigate
    private func navigateToHome() {
        // Xoá stack cũ, set Home làm root
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        let mainVC = MainController()
        let navController = UINavigationController(rootViewController: mainVC)
        navController.navigationBar.isHidden = true

        window.rootViewController = navController
        UIView.transition(with: window,
                         duration: 0.3,
                         options: .transitionCrossDissolve,
                         animations: nil)
    }
}
