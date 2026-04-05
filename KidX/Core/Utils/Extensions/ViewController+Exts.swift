//
//  ViewController+Exts.swift
//  MV_25119
//
//  Created by 𝙢𝙩 on 27/12/25.
//

import UIKit

private var dimViewKey: UInt8 = 0
private var activityIndicatorKey: UInt8 = 1

extension UIViewController {
    func showAlert(title: String,
                   message: String,
                   confirmTitle: String = "OK",
                   confirmStyle: UIAlertAction.Style = .default,
                   confirmHandler: (() -> Void)? = nil,
                   cancelTitle: String? = nil,
                   cancelHandler: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let cancelTitle = cancelTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                cancelHandler?()
            }
            alert.addAction(cancelAction)
        }
        
        let confirmAction = UIAlertAction(title: confirmTitle, style: confirmStyle) { _ in
            confirmHandler?()
        }
        alert.addAction(confirmAction)
        
        present(alert, animated: true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
