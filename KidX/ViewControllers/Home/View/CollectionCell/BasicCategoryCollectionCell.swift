//
//  BasicCategoryCollectionCell.swift
//  KidX
//
//  Created by mt on 13/6/26.
//

import UIKit

final class BasicCategoryCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var englishLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func configure(with category: BasicFlashCardCategory) {
        titleLabel.text = category.titleVi
        englishLabel.text = category.titleEn
        countLabel.text = String(format: "%d cards".localize(), category.items.count)
    }

    private func setupUI() {
        containerView.layer.cornerRadius = 18
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor(hex: 0xD7E6FF).cgColor
        containerView.addShadow(color: UIColor(hex: 0x00264D))
        countLabel.makeCircle()
    }
}
