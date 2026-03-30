//
//  UIFont+Exts.swift
//  MV_25119
//
//  Created by 𝙢𝙩 on 27/12/25.
//

import UIKit

extension UIFont {
    private static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private static var iPadFontMultiplier: CGFloat {
        return 1.5
    }
    
    private static func adjustedSize(for size: CGFloat) -> CGFloat {
        return isIPad ? size * iPadFontMultiplier : size
    }
    
    static func playRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Play-Regular",
                      size: adjustedSize(for: size)) ?? UIFont.systemFont(ofSize: adjustedSize(for: size))
    }
    
    static func playBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Play-Bold",
                      size: adjustedSize(for: size)) ?? UIFont.systemFont(ofSize: adjustedSize(for: size))
    }
}

