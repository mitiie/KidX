//
//  MissionTableCell.swift
//  KidX
//
//  Created by 𝙢𝙩 on 11/6/26.
//

import UIKit

class MissionTableCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var iconBgView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var starBadgeView: UIView!
    
    private var onStartTapped: (() -> Void)?
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update gradient frame to match startButton bounds
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = startButton.bounds
        CATransaction.commit()
        
        // Add card shadow path
        layer.shadowPath = UIBezierPath(roundedRect: cardView.frame, cornerRadius: 24).cgPath
    }
    
    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Card shadow on the cell's main layer
        layer.shadowColor = UIColor(hex: 0x00264D).cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 12
        layer.shadowOffset = CGSize(width: 0, height: 6)
        
        // Setup start button gradient layer
        gradientLayer.colors = [
            UIColor(hex: 0x006095).cgColor,
            UIColor(hex: 0x35ADFF).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 24
        
        // Setup fonts
        titleLabel.font = UIFont.custom(18, .semiBold)
        descLabel.font = UIFont.custom(13, .regular)
        startButton.titleLabel?.font = UIFont.custom(16, .semiBold)
        
        // Card corners
        cardView.layer.cornerRadius = 24
        iconBgView.layer.cornerRadius = 12
        starBadgeView.layer.cornerRadius = 16
        startButton.layer.cornerRadius = 24
        
        startButton.addTarget(self, action: #selector(btnStartTapped), for: .touchUpInside)
    }
    
    @objc private func btnStartTapped() {
        onStartTapped?()
    }
    
    // MARK: - Configuration
    func configData(with data: MissionData, onStart: @escaping () -> Void) {
        self.onStartTapped = onStart
        
        titleLabel.text = data.title
        descLabel.text = data.description
        
        // Icon
        iconImageView.image = UIImage(systemName: data.iconSymbol)
        let primaryColor = UIColor(hex: UInt32(data.iconBgColorHex, radix: 16) ?? 0x35ADFF)
        iconImageView.tintColor = primaryColor
        iconBgView.backgroundColor = primaryColor.withAlphaComponent(0.2)
        
        // Completed State
        starBadgeView.isHidden = !data.isCompleted
        
        // Button style
        if data.isCompleted {
            startButton.setTitle("Đã hoàn thành".localize(), for: .normal)
            gradientLayer.removeFromSuperlayer()
            startButton.backgroundColor = UIColor(hex: 0x4CD964) // Green
            startButton.isUserInteractionEnabled = false
        } else {
            startButton.setTitle("Bắt đầu  ▷".localize(), for: .normal)
            startButton.isUserInteractionEnabled = true
            
            if let btnHex = data.buttonColorHex, let customColorHex = UInt32(btnHex, radix: 16) {
                gradientLayer.removeFromSuperlayer()
                startButton.backgroundColor = UIColor(hex: customColorHex)
            } else {
                startButton.backgroundColor = .clear
                startButton.layer.insertSublayer(gradientLayer, at: 0)
            }
        }
    }
}
