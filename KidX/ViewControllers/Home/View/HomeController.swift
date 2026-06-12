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
    private enum Row: Int, CaseIterable {
        case popular
        case basic
    }

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
        tableView.registerNib(for: BasicTableCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allCases.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let row = Row(rawValue: indexPath.row) else { return 0 }

        switch row {
        case .popular:
            return 300
        case .basic:
            return 230
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }

        switch row {
        case .popular:
            let cell: PopularTableCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: viewModel.popularCategories)
            cell.delegate = self
            return cell

        case .basic:
            let cell: BasicTableCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: viewModel.basicCategories)
            cell.delegate = self
            return cell
        }
    }
}

extension HomeController: PopularTableCellDelegate {
    func popularTableCell(_ cell: PopularTableCell, didSelectCategory category: PopularFlashCardCategory) {
        viewModel.navigateToListFlashCard(category: category)
    }
}

extension HomeController: BasicTableCellDelegate {
    func basicTableCell(_ cell: BasicTableCell, didSelectCategory category: BasicFlashCardCategory) {
        viewModel.navigateToListFlashCardBasic(category: category)
    }
}
