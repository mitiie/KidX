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
    
    private var dimView: UIView? {
        get { objc_getAssociatedObject(self, &dimViewKey) as? UIView }
        set { objc_setAssociatedObject(self, &dimViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var activityIndicator: UIActivityIndicatorView? {
        get { objc_getAssociatedObject(self, &activityIndicatorKey) as? UIActivityIndicatorView }
        set { objc_setAssociatedObject(self, &activityIndicatorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func showLoading() {
        guard activityIndicator == nil else { return }

        let dim = UIView(frame: view.bounds)
        dim.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dim.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(dim)
        self.dimView = dim

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor.white
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        self.activityIndicator = indicator

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        indicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil

        dimView?.removeFromSuperview()
        dimView = nil
    }
}
