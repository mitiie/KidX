//
//  LoginViewModel.swift
//  KidX
//
//  Created by 𝙢𝙩 on 5/4/26.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

final class LoginViewModel {
    private let navigation: NavigationState<AuthRoute>
    
    init(navigation: NavigationState<AuthRoute>) {
        self.navigation = navigation
    }
    
    // MARK: - Validation
    func validate(email: String, password: String) -> LoginError? {
        let email = email.trimmingCharacters(in: .whitespaces)
        if email.isEmpty        { return .emptyEmail }
        if !isValidEmail(email) { return .invalidEmail }
        if password.isEmpty     { return .emptyPassword }
        if password.count < 6   { return .passwordTooShort }
        return nil
    }
    
    func isValidEmail(_ email: String) -> Bool {
        return email.isValidEmail
    }
    
    // MARK: - Email Login
    func loginWithEmail(email: String,
                        password: String,
                        completion: @escaping (Result<Void, LoginError>) -> Void) {
        let email = email.trimmingCharacters(in: .whitespaces)
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self else { return }
            
            if let error = error {
                completion(.failure(self.mapFirebaseError(error)))
                return
            }
            guard let user = authResult?.user else {
                completion(.failure(.unknown("Unexpected error")))
                return
            }
            if !user.isEmailVerified {
                try? Auth.auth().signOut()
                completion(.failure(.emailNotVerified))
                return
            }
            completion(.success(()))
        }
    }
    
    // MARK: - Password Reset
    func sendPasswordReset(email: String,
                           completion: @escaping (LoginError?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self else { return }
            if let error = error {
                completion(self.mapFirebaseError(error))
                return
            }
            completion(nil)
        }
    }
    
    // MARK: - Resend Verification
    func resendVerificationEmail(user: User,
                                 completion: @escaping (LoginError?) -> Void) {
        user.sendEmailVerification { [weak self] error in
            guard let self else { return }
            if let error = error {
                completion(self.mapFirebaseError(error))
                return
            }
            completion(nil)
        }
    }
    
    // MARK: - Google Sign-In
    func signInWithGoogle(presenting viewController: UIViewController,
                          completion: @escaping (Result<Void, LoginError>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [weak self] result, error in
            guard let self else { return }
            
            if let error = error {
                print("❌ Google Sign-In error: \(error.localizedDescription)")
                completion(.failure(.unknown(error.localizedDescription)))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(.unknown("Failed to retrieve Google credentials")))
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("❌ Firebase Google Auth error: \(error.localizedDescription)")
                    completion(.failure(self.mapFirebaseError(error)))
                    return
                }
                guard let user = authResult?.user else {
                    completion(.failure(.unknown("Unexpected error")))
                    return
                }
                print("✅ Google Sign-In successful: \(user.uid)")
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Navigation
    func navigateToHome() {
        navigation.push(.main, isReplaceTop: true)
    }
    
    func navigateToRegister() {
        navigation.push(.register)
    }
    
    // MARK: - Error Mapping
    private func mapFirebaseError(_ error: Error) -> LoginError {
        let nsError = error as NSError
        guard let code = AuthErrorCode(rawValue: nsError.code) else {
            return .unknown(error.localizedDescription)
        }
        return .firebase(code)
    }
}
