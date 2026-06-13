//
//  LetterCollectionCell.swift
//  KidX
//
//  Created by 𝙢𝙩 on 14/6/26.
//

import UIKit

final class LetterCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var letterLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.shadowPath = UIBezierPath(
            roundedRect: cardView.bounds,
            cornerRadius: cardView.layer.cornerRadius
        ).cgPath
    }

    func configure(with letter: AlphabetLetter) {
        cardView.backgroundColor = UIColor(hex: 0xFFF3E0)
        letterLabel.attributedText = makeLetterText(letter)
    }

    private func setupUI() {
        contentView.backgroundColor = .clear
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowColor = UIColor(hex: 0x8B5E2A).cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 8
        letterLabel.textAlignment = .center
        letterLabel.adjustsFontSizeToFitWidth = true
        letterLabel.minimumScaleFactor = 0.72
    }

    private func makeLetterText(_ letter: AlphabetLetter) -> NSAttributedString {
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(
            string: letter.uppercase,
            attributes: attributes(
                size: 46,
                fillColor: UIColor(hex: letter.primaryHex),
                strokeColor: UIColor(hex: 0x7C4B54)
            )
        ))
        text.append(NSAttributedString(
            string: letter.lowercase,
            attributes: attributes(
                size: 38,
                fillColor: UIColor(hex: letter.secondaryHex),
                strokeColor: UIColor(hex: 0x7C4B54)
            )
        ))
        return text
    }

    private func attributes(size: CGFloat, fillColor: UIColor, strokeColor: UIColor) -> [NSAttributedString.Key: Any] {
        [
            .font: UIFont.custom(size, .cherryBombRegular),
            .foregroundColor: fillColor,
            .strokeColor: strokeColor,
            .strokeWidth: -4
        ]
    }
}
