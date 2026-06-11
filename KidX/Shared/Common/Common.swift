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
    
    static func triggerConfetti(in view: UIView) {
        let colors: [UIColor] = [
            UIColor(hex: 0xFF3B30), // Red
            UIColor(hex: 0xFFCC00), // Gold/Yellow
            UIColor(hex: 0x007AFF), // Blue
            UIColor(hex: 0x34C759), // Green
            UIColor(hex: 0xFF9500), // Orange
            UIColor(hex: 0xAF52DE), // Purple
            UIColor(hex: 0xFF2D55)  // Pink
        ]
        
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: view.bounds.midX, y: -20)
        emitter.emitterSize = CGSize(width: view.bounds.width, height: 1)
        emitter.emitterShape = .rectangle
        emitter.emitterMode = .volume
        
        func makeConfettiImage(color: UIColor, size: CGSize = CGSize(width: 5, height: 10)) -> UIImage {
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { ctx in
                color.setFill()
                ctx.cgContext.fill(CGRect(origin: .zero, size: size))
            }
        }
        
        var cells: [CAEmitterCell] = []
        for color in colors {
            let cell = CAEmitterCell()
            cell.birthRate = 12
            cell.lifetime = 5.0
            cell.lifetimeRange = 1.0
            cell.velocity = 120
            cell.velocityRange = 40
            cell.yAcceleration = 80 // Gentle down pull
            cell.emissionLongitude = .pi / 2 // Downward direction
            cell.emissionRange = .pi / 4     // Spread angle
            cell.spin = 3.5
            cell.spinRange = 4.0
            cell.scale = 0.6
            cell.scaleRange = 0.2
            
            let image = makeConfettiImage(color: color, size: CGSize(width: 5, height: 10))
            cell.contents = image.cgImage
            
            cells.append(cell)
        }
        
        emitter.emitterCells = cells
        view.layer.addSublayer(emitter)
        
        // Stop emitting after 1.5 seconds, then remove the emitter layer from screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            emitter.birthRate = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            emitter.removeFromSuperlayer()
        }
    }
}

