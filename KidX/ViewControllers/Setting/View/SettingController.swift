//
//  SettingController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 26/3/26.
//

import UIKit

class SettingController: UIViewController {

    private let viewModel: SettingViewModel
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - IBActions
    @IBAction func btnLogoutTapped(_ sender: UIButton) {
        viewModel.logout { [weak self] error in
            guard let self else { return }
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            self.viewModel.navigateToLogin()
        }
    }
}
