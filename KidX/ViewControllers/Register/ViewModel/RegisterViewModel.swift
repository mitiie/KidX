//
//  RegisterViewModel.swift
//  KidX
//
//  Created by 𝙢𝙩 on 5/4/26.
//

import FirebaseAuth

final class RegisterViewModel {
    private let navigation: NavigationState<AuthRoute>

    init(navigation: NavigationState<AuthRoute>) {
        self.navigation = navigation
    }

    // MARK: - Validation
    func validate(email: String, password: String, confirmPassword: String) -> RegisterError? {
        let email = email.trimmingCharacters(in: .whitespaces)
        if email.isEmpty        { return .emptyEmail }
        if !email.isValidEmail  { return .invalidEmail }
        if password.isEmpty     { return .emptyPassword }
        if password.count < 6   { return .passwordTooShort }
        if confirmPassword.isEmpty  { return .emptyConfirmPassword }
        if password != confirmPassword { return .passwordMismatch }
        return nil
    }

    // MARK: - Register
    func register(email: String,
                  password: String,
                  completion: @escaping (Result<Void, RegisterError>) -> Void) {
        let email = email.trimmingCharacters(in: .whitespaces)

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self else { return }

            if let error = error {
                completion(.failure(self.mapFirebaseError(error)))
                return
            }

            guard let user = authResult?.user else {
                completion(.failure(.unknown("Unexpected error")))
                return
            }

            print("✅ User created: \(user.uid)")
            print("📧 Email: \(user.email ?? "")")

            user.sendEmailVerification { error in
                if let error = error {
                    print("❌ Failed to send verification email: \(error.localizedDescription)")
                } else {
                    print("✅ Verification email sent successfully")
                }
                completion(.success(()))
            }
        }
    }

    // MARK: - Navigation
    func navigateToLogin() {
        navigation.pop(animated: true)
    }

    func navigateBack() {
        navigation.pop(animated: true)
    }

    // MARK: - Error Mapping
    private func mapFirebaseError(_ error: Error) -> RegisterError {
        let nsError = error as NSError
        guard let code = AuthErrorCode(rawValue: nsError.code) else {
            return .unknown(error.localizedDescription)
        }
        return .firebase(code)
    }
}
