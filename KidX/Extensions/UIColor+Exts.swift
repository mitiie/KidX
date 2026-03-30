//
//  UIColor+Exts.swift
//  MV_25119
//
//  Created by 𝙢𝙩 on 27/12/25.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let red   = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8)  / 255.0
        let blue  = CGFloat(hex & 0x0000FF)         / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static let progressGradientColors: [UIColor] = [
        UIColor(hex: 0xFFEC1F),
        UIColor(hex: 0xFF4DB4)
    ]
}

extension CAGradientLayer {
    static func primaryGradient() -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(hex: 0x8A2387).cgColor,
            UIColor(hex: 0xE94057).cgColor,
            UIColor(hex: 0xF27121).cgColor  
        ]
        
        layer.locations = [0.0, 0.47, 1.0]
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        return layer
    }
    
    static func horizontal(colors: [UIColor]) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors      = colors.map(\.cgColor)
        layer.startPoint  = CGPoint(x: 0, y: 0.5)
        layer.endPoint    = CGPoint(x: 1, y: 0.5)
        return layer
    }
}
