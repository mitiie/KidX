//
//  String+Exts.swift
//  MV_2618
//
//  Created by 𝙢𝙩 on 4/2/26.
//

import UIKit
import Combine

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .eraseToAnyPublisher()
    }
}
