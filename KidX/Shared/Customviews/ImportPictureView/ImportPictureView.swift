//
//  ImportPictureView.swift
//  ARDrawing
//
//  Created by mitie on 14/4/26.
//

import UIKit

final class ImportPictureView: UIView, XibLoadable {
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var galleryGradientView: GradientView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraGradientView: GradientView!
    @IBOutlet weak var mainContentToCenterLayout: NSLayoutConstraint!
    @IBOutlet weak var dimView: UIView!

    var onDismiss: (() -> Void)?
    var onOpenGallery: (() -> Void)?
    var onOpenCamera: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
        setupUI()
    }
    
    @IBAction func btnDismissTapped(_ sender: Any) {
        onDismiss?()
        hide(true)
    }
    
    private func setupUI() {
        [galleryView, cameraView].forEach {
            $0?.addShadow()
        }
        
        galleryGradientView.setup(.topLeftToRightBottom, [UIColor(hex: 0x00D492).cgColor, UIColor(hex: 0x00B8DB).cgColor])
        cameraGradientView.setup(.topLeftToRightBottom, [UIColor(hex: 0x00D3F3).cgColor, UIColor(hex: 0x2B7FFF).cgColor])
        
        let galleryTap = UITapGestureRecognizer(target: self, action: #selector(galleryTapped))
        galleryView.addGestureRecognizer(galleryTap)
        
        let cameraTap = UITapGestureRecognizer(target: self, action: #selector(cameraTapped))
        cameraView.addGestureRecognizer(cameraTap)
    }
    
    @objc private func galleryTapped() {
        onOpenGallery?()
        hide(true)
    }
    
    @objc private func cameraTapped() {
        onOpenCamera?()
        hide(true)
    }
    
    func show(root: UIView, animated: Bool = true) {
        root.addSubview(self)
        self.layoutIfNeeded()
        self.setNeedsLayout()

        self.mainContentToCenterLayout.constant = 0.0
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.layoutIfNeeded()
            self.dimView.alpha = 1.0
        }
    }
    
    func hide(_ animated: Bool, didHideCompletion: (() -> Void)? = nil) {
        self.mainContentToCenterLayout.constant = 1000.0
        UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
            self.layoutIfNeeded()
            self.dimView.alpha = 0.0
        }) { (success) in
            self.removeFromSuperview()
            didHideCompletion?()
        }
    }
}
