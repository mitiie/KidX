//
//  SavedObjectCollectionViewCell.swift
//  KidX
//
//  Created by 𝙢𝙩 on 6/6/26.
//

import UIKit

final class SavedObjectCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var resultImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Draw the rounded shadow path matching cardView's bounds and cornerRadius
        cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: 24).cgPath
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Card styling
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 24
        cardView.layer.shadowColor = UIColor(hex: 0x00264D).cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowRadius = 8
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        // Image styling
        resultImageView.layer.cornerRadius = 16
        resultImageView.layer.borderWidth = 1
        resultImageView.layer.borderColor = UIColor(red: 0.827, green: 0.89, blue: 1, alpha: 1).cgColor
        resultImageView.clipsToBounds = true
        
        // Fonts
        nameLabel.font = UIFont.custom(15, .semiBold)
        dateLabel.font = UIFont.custom(11, .regular)
    }
    
    // MARK: - Configuration
    func configure(image: UIImage, name: String, dateText: String) {
        resultImageView.image = image
        nameLabel.text = name
        dateLabel.text = dateText
    }
}
