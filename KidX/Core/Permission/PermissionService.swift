//
//  PermissionService.swift
//  BaseApp
//
//  Created by Tran Van Quang on 12/1/26.
//
import AVFoundation
import Foundation
import Photos
import UIKit

protocol PermissionServiceProtocol {
    func checkPermission(_ type: PermissionType, showErrorAlert: Bool, completion: @escaping (_ isGranted: Bool) -> Void)
}

final class SystemPermissionService: PermissionServiceProtocol {
    func checkPermission(_ type: PermissionType, showErrorAlert: Bool, completion: @escaping (_ isGranted: Bool) -> Void) {
        Task {
            let currentStatus = await status(for: type)
            let resolvedStatus: PermissionStatus

            if currentStatus == .notDetermined {
                resolvedStatus = await request(type)
            } else {
                resolvedStatus = currentStatus
            }

            DispatchQueue.main.async {
                if resolvedStatus == .authorized {
                    completion(true)
                } else {
                    if showErrorAlert {
                        self.showPermissionAlert(for: type)
                    }
                    completion(false)
                }
            }
        }
    }
    
    private func status(for type: PermissionType) async -> PermissionStatus {
        switch type {
        case .camera:
            return mapCameraStatus(AVCaptureDevice.authorizationStatus(for: .video))
            
        case .microphone:
            return mapMicrophoneStatus(AVCaptureDevice.authorizationStatus(for: .audio))

        case .photoLibrary:
            return mapPhotoStatus(PHPhotoLibrary.authorizationStatus(for: .readWrite))

        }
    }
    
    private func request(_ type: PermissionType) async -> PermissionStatus {
        switch type {
        case .camera:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            return granted ? .authorized : .denied
            
        case .microphone:
            let granted = await AVCaptureDevice.requestAccess(for: .audio)
            return granted ? .authorized : .denied

        case .photoLibrary:
            let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            return mapPhotoStatus(status)
        }
    }

    private func showPermissionAlert(for type: PermissionType) {
        guard let topVC = UIApplication.topViewController() else { return }

        topVC.showAlert(
            title: type.title,
            message: type.desc,
            confirmTitle: "Settings".localize(),
            confirmHandler: {
                guard let url = URL(string: UIApplication.openSettingsURLString),
                      UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url)
            },
            cancelTitle: "Cancel".localize()
        )
    }
}

private extension SystemPermissionService {
    func mapCameraStatus(_ status: AVAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized: return .authorized
        case .denied: return .denied
        case .restricted: return .restricted
        @unknown default: return .denied
        }
    }

    func mapPhotoStatus(_ status: PHAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized, .limited: return .authorized
        case .denied: return .denied
        case .restricted: return .restricted
        @unknown default: return .denied
        }
    }

    func mapNotificationStatus(_ status: UNAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized, .provisional: return .authorized
        case .denied: return .denied
        case .ephemeral: return .authorized
        @unknown default: return .denied
        }
    }
    
    func mapMicrophoneStatus(_ status: AVAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized: return .authorized
        case .denied: return .denied
        case .restricted: return .restricted
        @unknown default: return .denied
        }
    }
}
