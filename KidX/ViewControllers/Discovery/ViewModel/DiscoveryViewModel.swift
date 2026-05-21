//
//  DiscoveryViewModel.swift
//  KidX
//
//  Created by 𝙢𝙩 on 22/5/26.
//

import Foundation
import UIKit

final class DiscoveryViewModel {

    var onOpenGallery: (() -> Void)?
    var onOpenCamera: (() -> Void)?

    private let navigation: NavigationState<MainRoute>
    private weak var importPictureView: ImportPictureView?

    init(navigation: NavigationState<MainRoute>) {
        self.navigation = navigation
    }

    func importPhoto(from rootView: UIView) {
        guard importPictureView == nil else { return }

        let importView = ImportPictureView(frame: rootView.bounds)
        importView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        importView.onDismiss = { [weak self] in
            self?.importPictureView = nil
        }

        importView.onOpenGallery = { [weak self] in
            self?.onOpenGallery?()
            self?.importPictureView = nil
        }

        importView.onOpenCamera = { [weak self] in
            self?.onOpenCamera?()
            self?.importPictureView = nil
        }

        importPictureView = importView
        importView.show(root: rootView)
    }
}
