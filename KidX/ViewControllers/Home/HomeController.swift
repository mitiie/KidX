//
//  HomeController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 26/3/26.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class HomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Ẩn nút back để không thể quay về Login
        navigationItem.hidesBackButton = true
    }

    // Gọi khi bấm nút logout
    @IBAction func btnLogoutTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            navigateToLogin()
        } catch {
            print("Lỗi logout: \(error.localizedDescription)")
        }
    }

    private func navigateToLogin() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        let loginVC = LoginController()
        let navController = UINavigationController(rootViewController: loginVC)
        navController.navigationBar.isHidden = true

        window.rootViewController = navController
        UIView.transition(with: window,
                         duration: 0.3,
                         options: .transitionCrossDissolve,
                         animations: nil)
    }
}
