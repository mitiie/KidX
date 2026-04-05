//
//  UIView+Exts.swift
//  MV_2616
//
//  Created by 𝙢𝙩 on 20/1/26.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

extension UIView {
    private struct AssociatedKeys {
        static var tapClosure: UInt8 = 0
    }

    func onTap(action: @escaping () -> Void) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
        objc_setAssociatedObject(self, &AssociatedKeys.tapClosure, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    @objc private func handleTap() {
        if let action = objc_getAssociatedObject(self, &AssociatedKeys.tapClosure) as? () -> Void {
            action()
        }
    }
}

extension UIView {
    func applyPrimaryGradient() {
        self.layer.sublayers?.filter { $0.name == "primaryGradient" }.forEach { $0.removeFromSuperlayer() }
        
        let gradient = CAGradientLayer()
        gradient.name = "primaryGradient"
        
        gradient.colors = [
            UIColor(hex: 0x8A2387).cgColor,
            UIColor(hex: 0xE94057).cgColor,
            UIColor(hex: 0xF27121).cgColor
        ]
        
        gradient.locations = [0.0, 0.47, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
        self.clipsToBounds = true
    }
    
    func applyLinearBackground(alpha: CGFloat) {
        self.layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach { $0.removeFromSuperlayer() }

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
            UIColor(hex: 0xD1EDEA, alpha: alpha).cgColor,
            UIColor(hex: 0xFFEDF0, alpha: alpha).cgColor,
            UIColor(hex: 0xF0F6B7, alpha: alpha).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func makeCircle() {
        clipsToBounds = true
        layer.cornerRadius = bounds.height / 2
    }
    
    func makeRounded(radius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
        layer.cornerRadius  = radius
        layer.borderWidth   = borderWidth
        layer.borderColor   = borderColor.cgColor
        layer.masksToBounds = true
    }
}

extension UIView {
    @IBInspectable
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = circleCorner ? min(bounds.size.height, bounds.size.width) / 2 : newValue
        }
    }
    
    @IBInspectable
    public var circleCorner: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
        }
        set {
            cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
        }
    }
}

extension CALayer {
    func applyShadow(color: UIColor, alpha: Float, size: CGSize, blur: CGFloat, spread: CGFloat, cornerRadius: CGFloat) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = size
        shadowRadius = blur / 2.0
        masksToBounds = false
        
        let rect = bounds.insetBy(dx: -spread, dy: -spread)
        shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
    }
}
