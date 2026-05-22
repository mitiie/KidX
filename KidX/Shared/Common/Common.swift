//
//  Utils.swift
//  BaseApp
//
//  Created by Tran Van Quang on 23/12/25.
//

import PhotosUI
import UIKit

final class Common {
    static func showLoading() {
        DispatchQueue.main.async {
            guard let topVC = UIApplication.topViewController() else { return }
            let loading = AppLoadingView(frame: topVC.view.bounds)
            loading.show(true)
        }
    }
    
    static func hideLoading(animated: Bool = true) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared
                    .connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .flatMap({ $0.windows })
                    .first(where: { $0.isKeyWindow }) else { return }
            for view in window.subviews {
                guard let view = view as? AppLoadingView else { continue }
                view.hide(animated)
            }
        }
    }
    
    static func openWebBrowser(_ urlString: String) {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    static func openSystemCamera(from vc: UIViewController, delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let alert = UIAlertController(title: "Error", message: "Camera is not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            vc.present(alert, animated: true)
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = delegate
        picker.allowsEditing = false
        DispatchQueue.main.async {
            vc.present(picker, animated: true)
        }
    }

    static func openPhotoLibrary(from vc: UIViewController, delegate: PHPickerViewControllerDelegate?) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = delegate
        DispatchQueue.main.async {
            vc.present(picker, animated: true)
        }
    }
}
