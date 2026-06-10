//
//  ListGameViewModel.swift
//  KidX
//
//  Created by mt on 11/6/26.
//

import Foundation
import PhotosUI
import UIKit

final class ListGameViewModel {
    private let navigation: NavigationState<MainRoute>
    private let permissionService: PermissionServiceProtocol
    private weak var importPictureView: ImportPictureView?

    init(navigation: NavigationState<MainRoute>,
         permissionService: PermissionServiceProtocol = SystemPermissionService()) {
        self.navigation = navigation
        self.permissionService = permissionService
    }

    func importPhoto(from rootView: UIView,
                     presenter: UIViewController,
                     imagePickerDelegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?,
                     photoPickerDelegate: PHPickerViewControllerDelegate?) {
        guard importPictureView == nil else { return }

        let importView = ImportPictureView(frame: rootView.bounds)
        importView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        importView.onDismiss = { [weak self] in
            self?.importPictureView = nil
        }

        importView.onOpenGallery = { [weak self] in
            self?.openPhotoLibrary(from: presenter, delegate: photoPickerDelegate)
            self?.importPictureView = nil
        }

        importView.onOpenCamera = { [weak self] in
            self?.openCamera(from: presenter, delegate: imagePickerDelegate)
            self?.importPictureView = nil
        }

        importPictureView = importView
        importView.show(root: rootView)
    }

    private func openPhotoLibrary(from presenter: UIViewController,
                                  delegate: PHPickerViewControllerDelegate?) {
        permissionService.checkPermission(.photoLibrary, showErrorAlert: true) { isGranted in
            guard isGranted else { return }
            Common.openPhotoLibrary(from: presenter, delegate: delegate)
        }
    }

    private func openCamera(from presenter: UIViewController,
                            delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?) {
        permissionService.checkPermission(.camera, showErrorAlert: true) { isGranted in
            guard isGranted else { return }
            Common.openSystemCamera(from: presenter, delegate: delegate)
        }
    }
}
