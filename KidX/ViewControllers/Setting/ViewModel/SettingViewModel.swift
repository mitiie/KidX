//
//  SettingViewModel.swift
//  KidX
//
//  Created by 𝙢𝙩 on 6/4/26.
//

import FirebaseAuth
import GoogleSignIn

final class SettingViewModel {

    private let navigation: NavigationState<SettingRoute>

    init(navigation: NavigationState<SettingRoute>) {
        self.navigation = navigation
    }

    func logout(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            print("✅ Logout successful")
            completion(nil)
        } catch {
            print("❌ Logout failed: \(error.localizedDescription)")
            completion(error)
        }
    }

    func navigateToLogin() {
        navigation.push(.logout)
    }
}
