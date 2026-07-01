//
//  LoginError.swift
//  KidX
//
//  Created by 𝙢𝙩 on 5/4/26.
//

import FirebaseAuth

enum LoginError: Error {
    case emptyEmail
    case invalidEmail
    case emptyPassword
    case passwordTooShort
    case emailNotVerified
    case firebase(AuthErrorCode)
    case unknown(String)

    var message: String {
        switch self {
        case .emptyEmail:           return "Please enter your email".localize()
        case .invalidEmail:         return "Invalid email address".localize()
        case .emptyPassword:        return "Please enter your password".localize()
        case .passwordTooShort:     return "Password must be at least 6 characters".localize()
        case .emailNotVerified:     return "Please check your inbox and verify your email before signing in.".localize()
        case .firebase(let code):   return code.loginMessage
        case .unknown(let msg):     return msg.localize()
        }
    }
}

extension LoginError: Equatable {
    static func == (lhs: LoginError, rhs: LoginError) -> Bool {
        switch (lhs, rhs) {
        case (.emptyEmail, .emptyEmail),
             (.invalidEmail, .invalidEmail),
             (.emptyPassword, .emptyPassword),
             (.passwordTooShort, .passwordTooShort),
             (.emailNotVerified, .emailNotVerified):
            return true
        case (.firebase(let l), .firebase(let r)):
            return l == r
        case (.unknown(let l), .unknown(let r)):
            return l == r
        default:
            return false
        }
    }
}

extension AuthErrorCode {
    var loginMessage: String {
        switch self {
        case .wrongPassword, .invalidCredential:    return "Incorrect email or password".localize()
        case .userNotFound:                         return "Account not found".localize()
        case .userDisabled:                         return "This account has been disabled".localize()
        case .invalidEmail:                         return "Invalid email address".localize()
        case .tooManyRequests:                      return "Too many attempts. Please try again later".localize()
        case .networkError:                         return "Network error. Please check your connection and try again".localize()
        case .emailAlreadyInUse:                    return "This email is already in use".localize()
        case .weakPassword:                         return "Password is too weak".localize()
        default:                                    return "Something went wrong".localize()
        }
    }
}

enum RegisterError: Error {
    case emptyEmail
    case invalidEmail
    case emptyPassword
    case passwordTooShort
    case emptyConfirmPassword
    case passwordMismatch
    case firebase(AuthErrorCode)
    case unknown(String)

    var message: String {
        switch self {
        case .emptyEmail:           return "Please enter your email".localize()
        case .invalidEmail:         return "Invalid email address".localize()
        case .emptyPassword:        return "Please enter your password".localize()
        case .passwordTooShort:     return "Password must be at least 6 characters".localize()
        case .emptyConfirmPassword: return "Please confirm your password".localize()
        case .passwordMismatch:     return "Passwords do not match".localize()
        case .firebase(let code):   return code.registerMessage
        case .unknown(let msg):     return msg.localize()
        }
    }
}

extension RegisterError: Equatable {
    static func == (lhs: RegisterError, rhs: RegisterError) -> Bool {
        switch (lhs, rhs) {
        case (.emptyEmail, .emptyEmail),
             (.invalidEmail, .invalidEmail),
             (.emptyPassword, .emptyPassword),
             (.passwordTooShort, .passwordTooShort),
             (.emptyConfirmPassword, .emptyConfirmPassword),
             (.passwordMismatch, .passwordMismatch):
            return true
        case (.firebase(let l), .firebase(let r)):
            return l == r
        case (.unknown(let l), .unknown(let r)):
            return l == r
        default:
            return false
        }
    }
}

extension AuthErrorCode {
    var registerMessage: String {
        switch self {
        case .emailAlreadyInUse:    return "This email is already in use".localize()
        case .invalidEmail:         return "Invalid email address".localize()
        case .weakPassword:         return "Password is too weak. Please choose a stronger password".localize()
        case .networkError:         return "Network error. Please check your connection and try again".localize()
        default:                    return "Something went wrong".localize()
        }
    }
}
