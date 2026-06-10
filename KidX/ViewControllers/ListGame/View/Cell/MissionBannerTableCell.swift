//
//  MissionBannerTableCell.swift
//  KidX
//
//  Created by 𝙢𝙩 on 11/6/26.
//

import UIKit

class MissionBannerTableCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var progressCard: UIView!
    @IBOutlet private weak var progressValueLabel: UILabel!
    @IBOutlet private weak var progressBarFill: UIView!
    @IBOutlet private weak var progressBarTrack: UIView!
    @IBOutlet private weak var badgeContainer: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var trophyContainer: UIView!
    
    // MARK: - Properties
    private var progressWidthConstraint: NSLayoutConstraint?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Configure Progress Card style (corner radius + light blue border)
        progressCard.layer.cornerRadius = 24
        progressCard.layer.borderWidth = 1.5
        progressCard.layer.borderColor = UIColor(hex: 0xD2E4FF).cgColor
        progressCard.clipsToBounds = true
        
        // Corners for other elements
        badgeContainer.layer.cornerRadius = 12
        progressBarTrack.layer.cornerRadius = 6
        progressBarFill.layer.cornerRadius = 6
        trophyContainer.layer.cornerRadius = 24
        
        // Typography
        titleLabel.font = UIFont.custom(28, .semiBold)
        progressValueLabel.font = UIFont.custom(22, .semiBold)
    }
    
    // MARK: - Configuration
    func configData(completedCount: Int, totalCount: Int) {
        // Localized format for progress label
        let format = "%d/%d Missions".localize()
        progressValueLabel.text = String(format: format, completedCount, totalCount)
        
        // Calculate progress ratio
        let progressRatio = totalCount > 0 ? CGFloat(completedCount) / CGFloat(totalCount) : 0.0
        
        // Update progress bar fill constraint dynamically
        if let existing = progressWidthConstraint {
            progressBarTrack.removeConstraint(existing)
        }
        progressWidthConstraint = progressBarFill.widthAnchor.constraint(
            equalTo: progressBarTrack.widthAnchor,
            multiplier: progressRatio
        )
        progressWidthConstraint?.isActive = true
        
        layoutIfNeeded()
    }
}
