//
//  AppColor.swift
//  KidX
//
//  Created by 𝙢𝙩 on 31/3/26.
//

import UIKit

enum AppColor: String {
    case primary
    case text
    case white
    case error
    case grey
    
    var color: UIColor {
        switch self {
        case .primary:
            return UIColor(hex: 0x0077FF)
        case .text:
            return UIColor(hex: 0x445D7F)
        case .white:
            return UIColor.white
        case .error:
            return UIColor(hex: 0xFF0000)
        case .grey:
            return UIColor(hex: 0x6E6C6C)
        }
    }
}
