//
//  HomeViewModel.swift
//  KidX
//
//  Created by 𝙢𝙩 on 5/4/26.
//

import FirebaseAuth
import GoogleSignIn

final class HomeViewModel {

    private(set) var popularCategories: [PopularFlashCardCategory] = []
    private let navigation: NavigationState<HomeRoute>

    init(navigation: NavigationState<HomeRoute>) {
        self.navigation = navigation
    }

    func loadData() {
        popularCategories = PopularFlashCardService.loadCategories()
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
