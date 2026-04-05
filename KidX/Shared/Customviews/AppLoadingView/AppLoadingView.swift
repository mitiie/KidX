//
//  AppLoadingView.swift
//  BaseApp
//
//  Created by Tran Van Quang on 12/3/26.
//

import UIKit
import Lottie

class AppLoadingView: UIView {
    @IBOutlet weak var animatedView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var mainContentToCenterLayout: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }
    
    func loadNibContent() {
        let name = String(describing: AppLoadingView.self)
        guard let view = Bundle.main.loadNibNamed(name, owner: self, options: nil)?.first as? UIView else {
            fatalError("Could not load view from nib with name: \(name)")
        }
        view.frame = self.bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.addSubview(view)
    }
    
    func show(_ animated: Bool) {
        guard let window = UIApplication.shared
                .connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) else { return }

        let isShowing = window.subviews.contains(where: { $0 is AppLoadingView })
        guard !isShowing else { return }
        
        self.show(root: window)
    }
    
    private func show(root: UIView, animated: Bool = true) {
        root.addSubview(self)
        self.layoutIfNeeded()
        self.setNeedsLayout()
        
        let animationView = LottieAnimationView(name: "cat_anim.json")
        animationView.frame = self.animatedView.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        self.animatedView.addSubview(animationView)
    }
    
    func hide(_ animated: Bool) {
        self.mainContentToCenterLayout.constant = 600.0
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.blurView.alpha = 0.0
            self.layoutIfNeeded()
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}
