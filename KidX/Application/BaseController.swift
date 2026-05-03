//
//  BaseController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 30/3/26.
//

import UIKit

class BaseController: UIViewController {
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(resource: .icBg)
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupUI()
    }

    private func setupBackground() {
        view.backgroundColor = .white
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupUI() { }
}
