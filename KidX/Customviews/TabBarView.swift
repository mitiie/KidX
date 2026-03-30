//
//  TabBarView.swift
//  MV_2617
//
//  Created by 𝙢𝙩 on 26/1/26.
//

import UIKit

protocol TabBarViewDelegate: AnyObject {
    func didSelectTab(_ tab: TabBarItem)
}

class TabBarView: UIView {
    weak var delegate: TabBarViewDelegate?
    private var selectedIndex = 0
    private let tabItems: [TabBarItem] = TabBarItem.allCases
    private var buttons: [UIButton] = []
    
    private var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    private var buttonSize: CGFloat {
        return isPad ? 60.0 : 48.0
    }
    private let selectedButtonScale: CGFloat = 1.5
    private var scaledButtonDiameter: CGFloat {
        return buttonSize * selectedButtonScale
    }
    private var bowlDepth: CGFloat {
        return scaledButtonDiameter / 2.0
    }
    private var bowlWidth: CGFloat {
        return scaledButtonDiameter * 1.75
    }
    private let gradientLayer = CAGradientLayer.primaryGradient()
    private let shapeLayer = CAShapeLayer()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupStackView()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        updateShapePath(animated: false)
        updateButtonPositions(animated: false)
    }
    
    private func setupView() {
        backgroundColor = .clear
        shapeLayer.fillColor = UIColor.white.cgColor
        gradientLayer.mask = shapeLayer
        layer.addSublayer(gradientLayer)

    }
    
    private func setupStackView() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, tabItem) in tabItems.enumerated() {
            let container = UIView()
            stackView.addArrangedSubview(container)
            
            let button = UIButton(type: .custom)
            button.setImage(tabItem.image(isSelected: index == selectedIndex)?.withRenderingMode(.alwaysOriginal), for: .normal)
            
            if isPad {
                button.imageView?.contentMode = .scaleAspectFill
            }
            
            button.tag = index
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(button)
            buttons.append(button)
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: buttonSize),
                button.heightAnchor.constraint(equalToConstant: buttonSize),
                button.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                button.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
        }
    }
    
    private func updateShapePath(animated: Bool) {
        let width = bounds.width
        let height = bounds.height
        let itemWidth = width / CGFloat(tabItems.count)
        let centerLoc = itemWidth * CGFloat(selectedIndex) + (itemWidth / 2)
        
        let currentBowlWidth = self.bowlWidth
        let currentBowlDepth = self.bowlDepth
        
        let path = UIBezierPath()
        path.move(to: .zero)
        
        let leftEdge = centerLoc - (currentBowlWidth / 2)
        path.addLine(to: CGPoint(x: leftEdge, y: 0))
        
        let controlPointOffset1 = currentBowlWidth * 0.2
        let controlPointOffset2 = currentBowlWidth * 0.25
        
        path.addCurve(to: CGPoint(x: centerLoc, y: currentBowlDepth),
                      controlPoint1: CGPoint(x: leftEdge + controlPointOffset1, y: 0),
                      controlPoint2: CGPoint(x: centerLoc - controlPointOffset2, y: currentBowlDepth))
        
        let rightEdge = centerLoc + (currentBowlWidth / 2)
        path.addCurve(to: CGPoint(x: rightEdge, y: 0),
                      controlPoint1: CGPoint(x: centerLoc + controlPointOffset2, y: currentBowlDepth),
                      controlPoint2: CGPoint(x: rightEdge - controlPointOffset1, y: 0))
        
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        
        if animated {
            let animation = CABasicAnimation(keyPath: "path")
            animation.toValue = path.cgPath
            animation.duration = 0.4
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            shapeLayer.add(animation, forKey: "path")
        }
        
        shapeLayer.path = path.cgPath
    }
    
    private func updateButtonPositions(animated: Bool) {
        let duration = animated ? 0.4 : 0.0
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            for (index, button) in self.buttons.enumerated() {
                if index == self.selectedIndex {
                    let currentCenterY = button.center.y > 0 ? button.center.y : self.bounds.height / 2
                    let targetCenterY: CGFloat = self.isPad ? 16.0 : 10.0
                    let translationY = targetCenterY - currentCenterY
                    let translation = CGAffineTransform(translationX: 0, y: translationY)
                    let scale = CGAffineTransform(scaleX: self.selectedButtonScale, y: self.selectedButtonScale)
                    button.transform = translation.concatenating(scale)
                } else {
                    button.transform = .identity
                }
            }
        }
    }

    @objc private func tabButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index != selectedIndex else { return }
        
        let previousIndex = selectedIndex
        selectedIndex = index
        
        buttons[previousIndex].setImage(tabItems[previousIndex].image(isSelected: false)?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttons[index].setImage(tabItems[index].image(isSelected: true)?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        updateShapePath(animated: true)
        updateButtonPositions(animated: true)
        
        delegate?.didSelectTab(tabItems[index])
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !isHidden && isUserInteractionEnabled && alpha > 0 else { return nil }
        
        for button in buttons {
            let buttonPoint = button.convert(point, from: self)
            if button.bounds.contains(buttonPoint) {
                return button
            }
        }
        return super.hitTest(point, with: event)
    }
}
