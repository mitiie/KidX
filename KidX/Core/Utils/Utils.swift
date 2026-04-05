//
//  Utils.swift
//  BaseApp
//
//  Created by Tran Van Quang on 23/12/25.
//

import UIKit

final class Utils {
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
}
