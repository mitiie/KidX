//
//  SettingController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 26/3/26.
//

import UIKit
import Lottie

class ProfileController: BaseController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animateView: UIView!
    @IBOutlet weak var btnLogout: UIButton!
    
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func setupUI() {
        let animationView = LottieAnimationView(name: "profile_anim.json")
        animationView.frame = self.animateView.bounds
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        
        self.animateView.addSubview(animationView)
        
        setupLogoutButton()
    }
    
    private func setupLogoutButton() {
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.baseForegroundColor = .white
            config.baseBackgroundColor = UIColor(hex: 0xFF5B5B)
            
            // Icon config
            config.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
            config.imagePadding = 8
            config.imagePlacement = .leading
            
            // Background corners and border
            config.background.cornerRadius = 20
            config.background.strokeWidth = 2.5
            config.background.strokeColor = UIColor(hex: 0x2C2C2C)
            
            // Set font size
            var titleAttr = AttributeContainer()
            titleAttr.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            config.attributedTitle = AttributedString("Logout", attributes: titleAttr)
            
            btnLogout.configuration = config
        } else {
            btnLogout.setTitle("Logout", for: .normal)
            btnLogout.titleLabel?.font = UIFont.custom(15, .cherryBombRegular)
            btnLogout.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
            btnLogout.backgroundColor = UIColor(hex: 0xFF5B5B)
            btnLogout.tintColor = .white
            btnLogout.layer.cornerRadius = 20
            btnLogout.layer.borderWidth = 2.5
            btnLogout.layer.borderColor = UIColor(hex: 0x2C2C2C).cgColor
            btnLogout.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        }
        
        // Add press bounce target actions
        btnLogout.addTarget(self, action: #selector(logoutButtonTouchDown), for: .touchDown)
        btnLogout.addTarget(self, action: #selector(logoutButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func logoutButtonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
        }, completion: nil)
    }
    
    @objc private func logoutButtonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [.allowUserInteraction, .curveEaseOut], animations: {
            sender.transform = .identity
        }, completion: nil)
    }

    private func setupTableView() {
        tableView.registerNib(for: SettingTableCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 64
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

extension ProfileController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettingItem.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingTableCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: SettingItem.allCases[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.handleAction(SettingItem.allCases[indexPath.row])
    }
}
