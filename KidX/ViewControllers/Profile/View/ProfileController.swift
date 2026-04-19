//
//  SettingController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 26/3/26.
//

import UIKit

class ProfileController: BaseController {
    @IBOutlet weak var tableView: UITableView!
    
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
