//
//  BannerCollectionViewCell.swift
//  KidX
//
//  Created by 𝙢𝙩 on 6/6/26.
//

import UIKit

final class BannerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var containerCard: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    
    // MARK: - Callbacks
    var onStartTapped: (() -> Void)?
    
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerCard.bounds
        gradientLayer.cornerRadius = 32
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Gradient background
        let colors = [UIColor(hex: 0x0F71BA), UIColor(hex: 0x35A3EB)]
        gradientLayer.colors = colors.map(\.cgColor)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        containerCard.layer.insertSublayer(gradientLayer, at: 0)
        
        // Card shadow
        containerCard.layer.shadowColor = UIColor(hex: 0x0F71BA).cgColor
        containerCard.layer.shadowOpacity = 0.2
        containerCard.layer.shadowRadius = 16
        containerCard.layer.shadowOffset = CGSize(width: 0, height: 8)
        
        // Fonts
        titleLabel.font = UIFont.custom(24, .cherryBombRegular)
        subtitleLabel.font = UIFont.custom(14, .regular)
        
        // Start button shadow & fonts
        startButton.layer.cornerRadius = 20
        startButton.titleLabel?.font = UIFont.custom(16, .semiBold)
        startButton.layer.shadowColor = UIColor(hex: 0xFFC700).cgColor
        startButton.layer.shadowOpacity = 0.3
        startButton.layer.shadowRadius = 8
        startButton.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    @IBAction private func startButtonTapped(_ sender: Any) {
        onStartTapped?()
    }
}
