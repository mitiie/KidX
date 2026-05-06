//
//  ListFlashCardVC.swift
//  MV_2570
//
//  Created by Bui Minh Tien on 30/6/25.
//

import UIKit

class ListFlashCardVC: BaseController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var letReviewLabel: UILabel!
    @IBOutlet weak var letReviewContainer: UIView!
    
    private let viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
    }

    func configureData(popularCategory: PopularFlashCardCategory, title: String) {
        viewModel.selectCategory(popularCategory)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    override func setupUI() {
        label.text = viewModel.titleText
        let tap = UITapGestureRecognizer(target: self, action: #selector(letReviewTapped))
        letReviewContainer.addGestureRecognizer(tap)
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(for: FlashCardCell.self)
    }

    @objc private func letReviewTapped() {
        let optionView = OptionLearnView(frame: view.bounds)
        optionView.alpha = 0
        optionView.backgroundColor = UIColor(hex: 0xCDDBFF, alpha: 0.7)
        view.addSubview(optionView)

        UIView.animate(withDuration: 0.25) {
            optionView.alpha = 1
        }

        optionView.onLearnStarTapped = { [weak self] in
            guard let self = self else { return }
            optionView.removeFromSuperview()

            let unremembered = self.viewModel.getUnrememberedItems()
            guard !unremembered.isEmpty else {
                self.presentAlert(message: "All cards are remembered!")
                return
            }

            let detailVM = FlashCardDetailViewModel(items: unremembered, category: "Unremembered")
            let detailVC = FlashCardDetailVC(viewModel: detailVM)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }

        optionView.onRandomTapped = { [weak self] in
            guard let self = self else { return }
            optionView.removeFromSuperview()

            let items = self.viewModel.getRandomizedItems()

            let detailVM = FlashCardDetailViewModel(items: items, category: "Random Learning")
            let detailVC = FlashCardDetailVC(viewModel: detailVM)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissOptionView(_:)))
        optionView.addGestureRecognizer(tap)
    }

    @objc private func dismissOptionView(_ sender: UITapGestureRecognizer) {
        guard let optionView = sender.view as? OptionLearnView else { return }
        let location = sender.location(in: optionView)
        if !optionView.view1.frame.contains(location) && !optionView.view2.frame.contains(location) {
            UIView.animate(withDuration: 0.2) {
                optionView.alpha = 0
            } completion: { _ in
                optionView.removeFromSuperview()
            }
        }
    }

    @IBAction func btnBackTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    private func presentAlert(message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ListFlashCardVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FlashCardCell = collectionView.dequeueReusableCell(for: indexPath)
        let item = viewModel.itemList[indexPath.item]
        cell.configure(with: item)

        if indexPath.item == viewModel.itemList.count - 1 {
            cell.onAddTapped = { [weak self] in
                self?.presentCreateFlashCardScreen()
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let reordered = viewModel.reorderItems(at: indexPath.item)

        let detailVM = FlashCardDetailViewModel(items: reordered, category: viewModel.titleText)
        let detailVC = FlashCardDetailVC(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    private func presentCreateFlashCardScreen() {
//        guard let category = currentUserCategory else { return }
//
//        let createVC = CreateFlashCardVC()
//        createVC.configure(with: category)
//
//        createVC.onCardCreated = { [weak self] in
//            guard let self = self else { return }
//            if let updatedCategory = UserFlashCardService.getCategory(with: category.id) {
//                self.configureData(userCategory: updatedCategory, title: self.titleText)
//                self.collectionView.reloadData()
//            }
//        }
//
//        navigationController?.pushViewController(createVC, animated: true)
    }
}

extension ListFlashCardVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let interItemSpacing: CGFloat = 16
        let totalSpacing = padding * 2 + interItemSpacing
        let width = (collectionView.bounds.width - totalSpacing) / 2
        let height = width * 1.46
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16 
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 100, right: 16)
    }
}
