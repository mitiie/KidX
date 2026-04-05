//
//  UITextField+Exts.swift
//  KidX
//
//  Created by 𝙢𝙩 on 31/3/26.
//

import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .eraseToAnyPublisher()
    }
    
    func setHorizontalPadding(_ value: CGFloat) {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: value, height: frame.height))
        leftView  = padding
        rightView = padding
        leftViewMode  = .always
        rightViewMode = .always
    }
}
