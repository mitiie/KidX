//
//  HomeController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 26/3/26.
//

import UIKit

class HomeController: BaseController {
    @IBOutlet weak var tableView: UITableView!
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        viewModel.loadData()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(for: PopularTableCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PopularTableCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: viewModel.popularCategories)
        cell.delegate = self
        return cell
    }
}

extension HomeController: PopularTableCellDelegate {
    func popularTableCell(_ cell: PopularTableCell, didSelectCategory category: PopularFlashCardCategory) {
        let vc = ListFlashCardVC(viewModel: viewModel)
        vc.configureData(popularCategory: category, title: category.category)
        navigationController?.pushViewController(vc, animated: true)
    }
}
