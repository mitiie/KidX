//
//  ListFlashCardBasicController.swift
//  KidX
//
//  Created by mt on 13/6/26.
//

import UIKit

final class ListFlashCardBasicController: BaseController, XibLoadable {
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!

    private let viewModel: ListFlashCardBasicViewModel
    private var flippedIndexes: Set<Int> = []

    init(viewModel: ListFlashCardBasicViewModel) {
        self.viewModel = viewModel
        super.init(nibName: Self.xibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupUI() {
        super.setupUI()
        bindHeader()
        setupCollectionView()
    }

    private func bindHeader() {
        backButton.setImage(UIImage(resource: .icFlcBack), for: .normal)
        titleLabel.text = viewModel.titleText
        subtitleLabel.text = viewModel.subtitleText
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(for: BasicFlashCardCollectionCell.self)
    }

    @IBAction private func handleBack(_ sender: UIButton) {
        viewModel.navigateBack()
    }
}

extension ListFlashCardBasicController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BasicFlashCardCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
        let item = viewModel.items[indexPath.item]
        cell.configure(with: item, isFlipped: flippedIndexes.contains(indexPath.item))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if flippedIndexes.contains(indexPath.item) {
            flippedIndexes.remove(indexPath.item)
        } else {
            flippedIndexes.insert(indexPath.item)
        }

        guard let cell = collectionView.cellForItem(at: indexPath) as? BasicFlashCardCollectionCell else {
            collectionView.reloadItems(at: [indexPath])
            return
        }

        cell.flip()
    }
}

extension ListFlashCardBasicController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalPadding: CGFloat = 40
        let spacing: CGFloat = 14
        let availableWidth = collectionView.bounds.width - horizontalPadding - spacing
        let width = availableWidth / 2
        return CGSize(width: width, height: width * 1.18)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 20, bottom: 110, right: 20)
    }
}
