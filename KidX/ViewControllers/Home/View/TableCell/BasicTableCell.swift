//
//  BasicTableCell.swift
//  KidX
//
//  Created by mt on 13/6/26.
//

import UIKit

protocol BasicTableCellDelegate: AnyObject {
    func basicTableCell(_ cell: BasicTableCell, didSelectCategory category: BasicFlashCardCategory)
}

final class BasicTableCell: UITableViewCell {
    @IBOutlet private weak var collectionView: UICollectionView!

    weak var delegate: BasicTableCellDelegate?

    private var categories: [BasicFlashCardCategory] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
    }

    func configure(with categories: [BasicFlashCardCategory]) {
        self.categories = categories
        collectionView.reloadData()
    }

    private func setupCollectionView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(for: BasicCategoryCollectionCell.self)
    }
}

extension BasicTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BasicCategoryCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: categories[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.basicTableCell(self, didSelectCategory: categories[indexPath.item])
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: min(collectionView.bounds.width * 0.8, 280), height: collectionView.bounds.height)
    }
}
