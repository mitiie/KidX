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
    
    // Programmatic buttons and indicator
    private let trashButton = UIButton(type: .system)
    private let selectionIndicator = UIImageView()
    
    var onDeleteTapped: (() -> Void)?
    var isSelectable = false {
        didSet {
            updateActionVisibility()
        }
    }
    
    var isItemSelected = false {
        didSet {
            selectionIndicator.image = UIImage(systemName: isItemSelected ? "checkmark.circle.fill" : "circle")
            selectionIndicator.tintColor = isItemSelected ? UIColor(hex: 0x007AFF) : .lightGray
        }
    }
    
    var showActions = false {
        didSet {
            updateActionVisibility()
        }
    }
    
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
        cardView.addShadow(color: UIColor(hex: 0x00264D))
        
        // Image styling
        resultImageView.layer.cornerRadius = 16
        resultImageView.layer.borderWidth = 1
        resultImageView.layer.borderColor = UIColor(red: 0.827, green: 0.89, blue: 1, alpha: 1).cgColor
        resultImageView.clipsToBounds = true
        
        // Fonts
        nameLabel.font = UIFont.custom(15, .semiBold)
        dateLabel.font = UIFont.custom(11, .regular)
        
        setupActionViews()
    }
    
    private func setupActionViews() {
        // Trash button for single delete
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        trashButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        trashButton.tintColor = .systemRed
        trashButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        trashButton.layer.cornerRadius = 14
        trashButton.layer.shadowColor = UIColor.black.cgColor
        trashButton.layer.shadowOpacity = 0.2
        trashButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        trashButton.layer.shadowRadius = 4
        trashButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        contentView.addSubview(trashButton)
        
        // Selection indicator for multi-select
        selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
        selectionIndicator.contentMode = .scaleAspectFit
        selectionIndicator.tintColor = .lightGray
        selectionIndicator.image = UIImage(systemName: "circle")
        selectionIndicator.backgroundColor = .white
        selectionIndicator.layer.cornerRadius = 12
        selectionIndicator.clipsToBounds = true
        
        contentView.addSubview(selectionIndicator)
        
        NSLayoutConstraint.activate([
            // Trash button on the top right of the card
            trashButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            trashButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            trashButton.widthAnchor.constraint(equalToConstant: 28),
            trashButton.heightAnchor.constraint(equalToConstant: 28),
            
            // Selection indicator on top left of the card
            selectionIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            selectionIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            selectionIndicator.widthAnchor.constraint(equalToConstant: 24),
            selectionIndicator.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        updateActionVisibility()
    }
    
    @objc private func deleteTapped() {
        onDeleteTapped?()
    }
    
    private func updateActionVisibility() {
        if showActions {
            if isSelectable {
                trashButton.isHidden = true
                selectionIndicator.isHidden = false
            } else {
                trashButton.isHidden = false
                selectionIndicator.isHidden = true
            }
        } else {
            trashButton.isHidden = true
            selectionIndicator.isHidden = true
        }
    }
    
    // MARK: - Configuration
    func configure(image: UIImage, name: String, dateText: String, showActions: Bool = false, isSelectable: Bool = false, isItemSelected: Bool = false) {
        resultImageView.image = image
        nameLabel.text = name
        dateLabel.text = dateText
        
        self.showActions = showActions
        self.isSelectable = isSelectable
        self.isItemSelected = isItemSelected
    }
}
