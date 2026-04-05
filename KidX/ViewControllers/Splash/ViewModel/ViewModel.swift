//
//  ViewModel.swift
//  KidX
//
//  Created by 𝙢𝙩 on 5/4/26.
//

import UIKit
import FirebaseAuth

final class SplashViewModel {
    
    private let navigation: NavigationState<AuthRoute>
    
    init(navigation: NavigationState<AuthRoute>) {
        self.navigation = navigation
    }
    
    func checkAuthAndNavigate() {
        if Auth.auth().currentUser != nil {
            navigation.push(.main, isReplaceTop: true)
        } else {
            navigation.push(.login, isReplaceTop: true)
        }
    }
}
