//
//  UITextField+Exts.swift
//  KidX
//
//  Created by 𝙢𝙩 on 31/3/26.
//

import UIKit

extension UITextField {
    func setHorizontalPadding(_ value: CGFloat) {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: value, height: frame.height))
        leftView  = padding
        rightView = padding
        leftViewMode  = .always
        rightViewMode = .always
    }
}
