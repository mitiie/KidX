//
//  UIWindow+Exts.swift
//  MV_2616
//
//  Created by 𝙢𝙩 on 20/1/26.
//

import UIKit

extension UINavigationController {
    func pushViewControllerFade(_ viewController: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        self.view.layer.add(transition, forKey: nil)
        
        self.pushViewController(viewController, animated: false)
    }
    
    func popViewControllerFade() {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        self.view.layer.add(transition, forKey: nil)
        self.popViewController(animated: false)
    }
}
