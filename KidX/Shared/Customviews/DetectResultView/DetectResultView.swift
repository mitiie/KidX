//
//  DetectResultView.swift
//  KidX
//
//  Created by 𝙢𝙩 on 29/5/26.
//

import UIKit

final class DetectResultView: UIView, XibLoadable {
    
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var backgroundDimView: UIView!
    @IBOutlet private weak var shadowsView: UIView!
    @IBOutlet private weak var shapesView: UIView!
    
    @IBOutlet private weak var badgeContainer: UIView!
    @IBOutlet private weak var badgeLabel: UILabel!
    @IBOutlet private weak var resultImageView: UIImageView!
    
    @IBOutlet private weak var objectNameLabel: UILabel!
    @IBOutlet private weak var audioButton: UIButton!
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var retryButton: UIButton!
    
    @IBOutlet private weak var starBadgeView: UIView!
    @IBOutlet private weak var starWhiteCircle: UIView!
    @IBOutlet private weak var starIconImageView: UIImageView!
    
    // MARK: - Callbacks
    var onSaveTapped: (() -> Void)?
    var onRetryTapped: (() -> Void)?
    var onAudioTapped: (() -> Void)?
    var onDismiss: (() -> Void)?
    
    private var shadowLayer: CALayer?
    private var shapesBackgroundLayer: CALayer?
    private var saveButtonGradient: CAGradientLayer?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
        setupUI()
    }
    
    // MARK: - Life Cycle & Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 1. Update shadow layer bounds & path (exact specification from your code)
        if let shadowLayer = shadowLayer {
            shadowLayer.bounds = shadowsView.bounds
            shadowLayer.position = CGPoint(x: shadowsView.bounds.midX, y: shadowsView.bounds.midY)
            shadowLayer.shadowPath = UIBezierPath(roundedRect: shadowsView.bounds, cornerRadius: 48).cgPath
        }
        
        // 2. Update shapes layer bounds (exact specification from your code)
        if let shapesLayer = shapesBackgroundLayer {
            shapesLayer.bounds = shapesView.bounds
            shapesLayer.position = CGPoint(x: shapesView.bounds.midX, y: shapesView.bounds.midY)
        }
        
        // 3. Update save button gradient frame & corner radius
        if let gradient = saveButtonGradient {
            gradient.frame = saveButton.bounds
            gradient.cornerRadius = saveButton.bounds.height / 2
        }
        
        // Bring button subviews to the front so the gradient layer doesn't cover them
        if let imageView = saveButton.imageView {
            saveButton.bringSubviewToFront(imageView)
        }
        if let titleLabel = saveButton.titleLabel {
            saveButton.bringSubviewToFront(titleLabel)
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        guard containerView != nil, backgroundDimView != nil else { return }
        
        setupGesture()
        setupCardShadowAndBorder()
        styleViews()
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDimViewTap))
        backgroundDimView.addGestureRecognizer(tapGesture)
        backgroundDimView.isUserInteractionEnabled = true
    }
    
    private func setupCardShadowAndBorder() {
        // Clear background of container
        containerView.backgroundColor = .clear
        
        // 1. Shadows View (exact specification from your code)
        shadowsView.clipsToBounds = false
        
        let shadowPath0 = UIBezierPath(roundedRect: shadowsView.bounds, cornerRadius: 48)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0, green: 0.376, blue: 0.584, alpha: 0.12).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 48
        layer0.shadowOffset = CGSize(width: 0, height: 12)
        layer0.bounds = shadowsView.bounds
        layer0.position = shadowsView.center
        
        shadowsView.layer.insertSublayer(layer0, at: 0)
        self.shadowLayer = layer0
        
        // 2. Shapes View (exact specification from your code)
        shapesView.clipsToBounds = true
        
        let layer1 = CALayer()
        layer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer1.bounds = shapesView.bounds
        layer1.position = shapesView.center
        
        shapesView.layer.insertSublayer(layer1, at: 0)
        self.shapesBackgroundLayer = layer1
        
        shapesView.layer.cornerRadius = 48
        shapesView.layer.borderWidth = 1
        shapesView.layer.borderColor = UIColor(red: 0.827, green: 0.89, blue: 1, alpha: 1).cgColor
    }
    
    private func styleViews() {
        // --- 1. Top Badge ---
        badgeContainer.layer.cornerRadius = 18
        badgeLabel.font = UIFont.custom(14, .semiBold)
        
        // --- Result Image View ---
        resultImageView.layer.cornerRadius = 16
        resultImageView.layer.borderWidth = 1
        resultImageView.layer.borderColor = UIColor(red: 0.827, green: 0.89, blue: 1, alpha: 1).cgColor
        resultImageView.clipsToBounds = true
        
        // --- 2. Object Row ---
        objectNameLabel.font = UIFont.custom(26, .semiBold)
        
        audioButton.layer.cornerRadius = 24
        audioButton.addTarget(self, action: #selector(handleAudioTap), for: .touchUpInside)
        // Audio button subtle shadow to match premium design
        audioButton.layer.shadowColor = UIColor(hex: 0xFFC000).cgColor
        audioButton.layer.shadowOpacity = 0.3
        audioButton.layer.shadowRadius = 6
        audioButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        // --- 3. Description Label ---
        descriptionLabel.textColor = AppColor.text.color
        descriptionLabel.font = UIFont.custom(16, .regular)
        
        // --- 4. Save Button ---
        saveButton.titleLabel?.font = UIFont.custom(18, .semiBold)
        saveButton.addTarget(self, action: #selector(handleSaveTap), for: .touchUpInside)
        
        // Fix for star image not displaying: set it programmatically with template rendering and explicit tint
        let starConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        if let starImage = UIImage(systemName: "star.fill", withConfiguration: starConfig)?.withRenderingMode(.alwaysTemplate) {
            saveButton.setImage(starImage, for: .normal)
            saveButton.tintColor = .white
            saveButton.imageView?.tintColor = .white
        }
        
        // Gradient layer for Save Button
        let gradient = CAGradientLayer.horizontal(colors: [UIColor(hex: 0x0D6CBE), UIColor(hex: 0x35A3EB)])
        saveButton.layer.insertSublayer(gradient, at: 0)
        saveButtonGradient = gradient
        
        // Shadow for Save Button
        saveButton.layer.shadowColor = UIColor(hex: 0x0D6CBE).cgColor
        saveButton.layer.shadowOpacity = 0.3
        saveButton.layer.shadowRadius = 12
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 6)
        
        // --- 5. Retry Button ---
        retryButton.titleLabel?.font = UIFont.custom(17, .semiBold)
        retryButton.addTarget(self, action: #selector(handleRetryTap), for: .touchUpInside)
        
        // --- 6. Top-Right Orange Star Badge ---
        starBadgeView.layer.cornerRadius = 28
        // Badge subtle shadow
        starBadgeView.layer.shadowColor = UIColor.black.cgColor
        starBadgeView.layer.shadowOpacity = 0.15
        starBadgeView.layer.shadowRadius = 6
        starBadgeView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        starWhiteCircle.layer.cornerRadius = 16
    }
    
    // MARK: - Actions
    @objc private func handleDimViewTap() {
        dismiss()
    }
    
    @objc private func handleSaveTap() {
        onSaveTapped?()
    }
    
    @objc private func handleRetryTap() {
        onRetryTapped?()
    }
    
    @objc private func handleAudioTap() {
        onAudioTapped?()
    }
    
    // MARK: - Public Configuration & Animations
    
    /// Configures the view with detected object name, descriptive text, and image.
    func configure(objectName: String, description: String, image: UIImage?) {
        objectNameLabel.text = objectName
        descriptionLabel.text = description
        resultImageView.image = image
    }
    
    /// Shows the result view on a parent view with custom fade & scale-up animation.
    func show(on view: UIView, objectName: String, description: String, image: UIImage?) {
        configure(objectName: objectName, description: description, image: image)
        
        self.frame = view.bounds
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(self)
        
        // Initial hidden state for animation
        self.backgroundDimView.alpha = 0
        self.containerView.alpha = 0
        self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.backgroundDimView.alpha = 1
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }, completion: nil)
    }
    
    /// Dismisses the result view with fade & scale-down animation.
    func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundDimView.alpha = 0
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.removeFromSuperview()
            self.onDismiss?()
        }
    }
}
