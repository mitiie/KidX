//
//  SplashController.swift
//  BaseApp
//
//  Created by Tran Van Quang on 8/2/26.
//

import UIKit

import UIKit
import FirebaseAuth

class SplashController: BaseController {
    @IBOutlet weak var progressView: GradientProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()

        progressView.progress = 0.0
        progressView.setProgress(1.0, duration: 3.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.checkAuthAndNavigate()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        progressView.makeCircle()
    }

    private func checkAuthAndNavigate() {
        if Auth.auth().currentUser != nil {
            // Đã từng đăng nhập → thẳng vào Home
            navigateTo(MainController())
        } else {
            navigateTo(LoginController())
        }
    }

    private func navigateTo(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
