//
//  GameCollectionViewCell.swift
//  KidX
//
//  Created by 𝙢𝙩 on 6/6/26.
//

import UIKit

final class GameCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var missionCard: UIView!
    @IBOutlet private weak var leftBorderView: UIView!
    
    @IBOutlet private weak var badgeView: UIView!
    @IBOutlet private weak var badgeLabel: UILabel!
    
    @IBOutlet private weak var missionTitleLabel: UILabel!
    @IBOutlet private weak var progressTitleLabel: UILabel!
    @IBOutlet private weak var progressValueLabel: UILabel!
    
    @IBOutlet private weak var progressBarContainer: UIView!
    @IBOutlet private weak var progressBarFill: UIView!
    
    @IBOutlet private weak var yellowStarCircle: UIView!
    @IBOutlet private weak var starImageView: UIImageView!
    
    private let progressFillGradient = CAGradientLayer()
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update progress bar fill gradient frame
        progressFillGradient.frame = progressBarFill.bounds
        progressFillGradient.cornerRadius = 8
        
        // Update cell shadow path to match missionCard frame with cornerRadius 32
        layer.shadowPath = UIBezierPath(roundedRect: missionCard.frame, cornerRadius: 32).cgPath
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Sections & card
        titleLabel.font = UIFont.custom(20, .cherryBombRegular)
        missionCard.layer.cornerRadius = 32
        missionCard.clipsToBounds = true
        
        // Card shadow (applied on the cell's main layer so it shows under clipsToBounds)
        layer.shadowColor = UIColor(hex: 0x00264D).cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 16
        layer.shadowOffset = CGSize(width: 0, height: 8)
        
        leftBorderView.backgroundColor = UIColor(hex: 0xFF952D)
        
        // Badge
        badgeView.backgroundColor = UIColor(hex: 0xFFF0E5)
        badgeView.layer.cornerRadius = 6
        badgeLabel.font = UIFont.custom(12, .semiBold)
        
        // Labels
        missionTitleLabel.font = UIFont.custom(22, .cherryBombRegular)
        progressTitleLabel.font = UIFont.custom(13, .regular)
        progressValueLabel.font = UIFont.custom(14, .semiBold)
        
        // Progress bar
        progressBarContainer.backgroundColor = UIColor(hex: 0xE8F2FC)
        progressBarContainer.layer.cornerRadius = 8
        progressBarContainer.clipsToBounds = true
        
        progressBarFill.backgroundColor = .clear
        
        let colors = [UIColor(hex: 0xFF952D), UIColor(hex: 0x8B4B00)]
        progressFillGradient.colors = colors.map(\.cgColor)
        progressFillGradient.startPoint = CGPoint(x: 0, y: 0.5)
        progressFillGradient.endPoint = CGPoint(x: 1, y: 0.5)
        progressBarFill.layer.insertSublayer(progressFillGradient, at: 0)
        
        // Yellow Star Circle
        yellowStarCircle.layer.cornerRadius = 28
        yellowStarCircle.layer.shadowColor = UIColor(hex: 0xFFC700).cgColor
        yellowStarCircle.layer.shadowOpacity = 0.3
        yellowStarCircle.layer.shadowRadius = 8
        yellowStarCircle.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
}
