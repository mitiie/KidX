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
extension String {
    var isValidEmail: Bool {
        let email = self.trimmingCharacters(in: .whitespaces)
        
        guard email.count >= 5 else { return false }
        
        guard !email.contains(" ") else { return false }
        
        let parts = email.components(separatedBy: "@")
        guard parts.count == 2 else { return false }
        
        let localPart = parts[0]
        let domainPart = parts[1]
        
        guard !localPart.isEmpty, localPart.count <= 64 else { return false }
        
        guard !localPart.hasPrefix("."), !localPart.hasSuffix(".") else { return false }
        
        guard !localPart.contains("..") else { return false }
        
        guard !domainPart.isEmpty, domainPart.count <= 255 else { return false }
        
        guard domainPart.contains(".") else { return false }
        
        guard !domainPart.hasPrefix("."), !domainPart.hasSuffix(".") else { return false }
        guard !domainPart.hasPrefix("-"), !domainPart.hasSuffix("-") else { return false }
        
        guard !domainPart.contains("..") else { return false }
        
        guard let tld = domainPart.components(separatedBy: ".").last,
              tld.count >= 2,
              tld.count <= 6,
              tld.allSatisfy({ $0.isLetter }) else { return false }
        
        let regex = "^[A-Z0-9a-z._%+\\-]+@[A-Za-z0-9.\\-]+\\.[A-Za-z]{2,6}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}
