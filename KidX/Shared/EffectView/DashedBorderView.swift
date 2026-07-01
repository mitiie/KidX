//
//  DashedBorderView.swift
//  KidX
//
//  Created by 𝙢𝙩 on 13/6/26.
//

import UIKit

class DashedBorderView: UIView {
    private let borderLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        borderLayer.strokeColor = UIColor(hex: 0xD0D7DE).cgColor
        borderLayer.fillColor = nil
        borderLayer.lineDashPattern = [6, 4]
        borderLayer.lineWidth = 2
        layer.addSublayer(borderLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
        borderLayer.frame = bounds
    }
}
