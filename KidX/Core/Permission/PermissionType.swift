//
//  PermissionType.swift
//  BaseApp
//
//  Created by Tran Van Quang on 12/1/26.
//

enum PermissionType: Hashable {
    case camera
    case microphone
    case photoLibrary
    
    var title: String {
        switch self {
        case .camera: "Camera Access".localize()
        case .microphone: "Microphone Access".localize()
        case .photoLibrary: "Photo Library Access".localize()
        }
    }
    
    var desc: String {
        switch self {
        case .camera: "Application needs permission to aceess Camera to take picture. Please grant the permisison in Settings".localize()
        case .microphone: "Application needs permission to aceess Microphone to record audio. Please grant the permisison in Settings".localize()
        case .photoLibrary: "Application needs permission to aceess Photo Library to pick photo. Please grant the permisison in Settings".localize()
        }
    }
}
