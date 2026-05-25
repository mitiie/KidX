//
//  SettingViewModel.swift
//  KidX
//
//  Created by 𝙢𝙩 on 6/4/26.
//

import FirebaseAuth
import GoogleSignIn
import StoreKit

import UIKit

final class ProfileViewModel {

    private let navigation: NavigationState<MainRoute>
    
    private(set) var selectedLanguage: LanguageModel? = LocalizeHelper.shared.currentLanguage()
    
    var languages: [LanguageModel] {
        return LocalizeHelper.generateLanguages()
    }

    init(navigation: NavigationState<MainRoute>) {
        self.navigation = navigation
    }

    func handleAction(_ item: SettingItem) {
        switch item {
        case .language: navigateToLanguage()
        case .update: Common.openWebBrowser(AppLinks.APP_STORE)
        case .feedback: showFeedback()
        case .rate: showRateApp()
        case .term: openTermOfUse()
        case .privacyPolicy: openPolicy()
        }
    }
    
    func navigateToLanguage() {
        navigation.push(.language(self))
    }
    
    func selectLanguage(_ language: LanguageModel) {
        self.selectedLanguage = language
    }
    
    func changedLanguageSuccessfully() {
        if let selectedLanguage = selectedLanguage {
            LocalizeHelper.shared.setLanguage(selectedLanguage)
            
            DispatchQueue.main.async {
                if let sceneDelegate = UIApplication.shared.connectedScenes
                    .first(where: { $0.activationState == .foregroundActive })?
                    .delegate as? SceneDelegate {
                    sceneDelegate.changeRootToMain()
                }
            }
        }
    }
    
    func goBack() {
        navigation.pop()
    }

    private func showFeedback() {

    }

    private func showRateApp() {
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }

        if #available(iOS 18.0, *) {
            AppStore.requestReview(in: scene)
        } else {
            SKStoreReviewController.requestReview(in: scene)
        }
    }

    func openPolicy() {
        openURL(AppLinks.PRIVACY_POLICY)
    }

    func openTermOfUse() {
        openURL(AppLinks.TERM_OF_USE)
    }

    private func openURL(_ urlString: String) {
        Common.openWebBrowser(urlString)
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
