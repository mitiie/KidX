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
    private var selectedIndex = 2
    private let tabItems: [TabBarItem] = TabBarItem.allCases
    
    private var buttons: [UIButton] = []
    private var labels: [UILabel] = []
    
    private var buttonSize: CGFloat {
        return 56.0
    }
    
    private let selectedButtonScale: CGFloat = 1.5
    private var scaledButtonDiameter: CGFloat {
        return buttonSize * selectedButtonScale
    }
    
    private var bowlDepth: CGFloat {
        return scaledButtonDiameter * 0.45
    }
    private var bowlWidth: CGFloat {
        return scaledButtonDiameter * 1.35
    }
    
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
        shapeLayer.frame = bounds
        updateShapePath(animated: false)
        updateButtonPositions(animated: false)
    }
    
    private func setupView() {
        backgroundColor = .clear
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: -3)
        shapeLayer.shadowOpacity = 0.1
        shapeLayer.shadowRadius = 16
        layer.insertSublayer(shapeLayer, at: 0)
    }
    
    private func setupStackView() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        labels.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        labels.removeAll()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, tabItem) in tabItems.enumerated() {
            let container = UIView()
            stackView.addArrangedSubview(container)
            
            let label = UILabel()
            label.text = tabItem.title
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)
            labels.append(label)
            
            let button = UIButton(type: .custom)
            button.setImage(tabItem.image(isSelected: index == selectedIndex)?.withRenderingMode(.alwaysOriginal), for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            addSubview(button)
            buttons.append(button)
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: buttonSize),
                button.heightAnchor.constraint(equalToConstant: buttonSize),
                button.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                button.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -10),
                
                label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: -5)
            ])
            
            updateLabel(labels[index], isSelected: index == selectedIndex)
        }
    }
    
    private func updateShapePath(animated: Bool) {
        let width = bounds.width
        let height = bounds.height
        guard !tabItems.isEmpty else { return }

        let padding: CGFloat = 24.0
        let stackWidth = width - padding * 2
        let itemWidth  = stackWidth / CGFloat(tabItems.count)

        let centerLoc = padding + itemWidth * CGFloat(selectedIndex) + itemWidth / 2

        let currentBowlDepth = self.bowlDepth
        let cornerRadius: CGFloat = 16.0
        let cpRatio: CGFloat = 0.6

        let rawLeft  = centerLoc - bowlWidth / 2
        let rawRight = centerLoc + bowlWidth / 2
        let leftEdge  = max(rawLeft,  0)
        let rightEdge = min(rawRight, width)

        let leftSpan  = centerLoc - leftEdge
        let rightSpan = rightEdge - centerLoc

        let path = UIBezierPath()

        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))

        let leftArcCenterX = min(cornerRadius, leftEdge + cornerRadius)
        path.addArc(
            withCenter: CGPoint(x: leftArcCenterX, y: cornerRadius),
            radius: cornerRadius,
            startAngle: .pi,
            endAngle: 3 * .pi / 2,
            clockwise: true
        )

        path.addLine(to: CGPoint(x: max(leftArcCenterX, leftEdge), y: 0))

        path.addCurve(
            to: CGPoint(x: centerLoc, y: currentBowlDepth),
            controlPoint1: CGPoint(x: leftEdge  + leftSpan  * cpRatio, y: 0),
            controlPoint2: CGPoint(x: centerLoc - leftSpan  * cpRatio, y: currentBowlDepth)
        )

        path.addCurve(
            to: CGPoint(x: rightEdge, y: 0),
            controlPoint1: CGPoint(x: centerLoc + rightSpan * cpRatio, y: currentBowlDepth),
            controlPoint2: CGPoint(x: rightEdge  - rightSpan * cpRatio, y: 0)
        )

        let rightArcCenterX = max(width - cornerRadius, rightEdge - cornerRadius)
        path.addLine(to: CGPoint(x: min(rightArcCenterX, rightEdge), y: 0))

        path.addArc(
            withCenter: CGPoint(x: rightArcCenterX, y: cornerRadius),
            radius: cornerRadius,
            startAngle: 3 * .pi / 2,
            endAngle: 0,
            clockwise: true
        )

        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()

        if animated {
            let fromPath = shapeLayer.presentation()?.path ?? shapeLayer.path
            shapeLayer.path = path.cgPath

            let animation = CABasicAnimation(keyPath: "path")
            animation.fromValue = fromPath
            animation.toValue   = path.cgPath
            animation.duration  = 0.2
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            shapeLayer.add(animation, forKey: "pathAnimation")
        } else {
            shapeLayer.path = path.cgPath
        }
    }
    
    private func updateButtonPositions(animated: Bool) {
        let duration = animated ? 0.4 : 0.0
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            for (index, button) in self.buttons.enumerated() {
                if index == self.selectedIndex {
                    let translationY: CGFloat = -32.0
                    let translation = CGAffineTransform(translationX: 0, y: translationY)
                    let scale = CGAffineTransform(scaleX: self.selectedButtonScale, y: self.selectedButtonScale)
                    
                    button.transform = scale.concatenating(translation)
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
        
        updateLabel(labels[previousIndex], isSelected: false)
        updateLabel(labels[index], isSelected: true)
        
        updateShapePath(animated: true)
        updateButtonPositions(animated: true)
        
        delegate?.didSelectTab(tabItems[index])
    }

    private func updateLabel(_ label: UILabel, isSelected: Bool) {
        label.font = UIFont.custom(.sm, isSelected ? .medium : .regular)
        label.textColor = isSelected ? UIColor(hex: 0x35ADFF) : UIColor(hex: 0x424242)
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
