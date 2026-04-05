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
        case .emptyEmail:           return "Please enter your email"
        case .invalidEmail:         return "Invalid email address"
        case .emptyPassword:        return "Please enter your password"
        case .passwordTooShort:     return "Password must be at least 6 characters"
        case .emailNotVerified:     return "Please check your inbox and verify your email before signing in."
        case .firebase(let code):   return code.loginMessage
        case .unknown(let msg):     return msg
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
        case .wrongPassword, .invalidCredential:    return "Incorrect email or password"
        case .userNotFound:                         return "Account not found"
        case .userDisabled:                         return "This account has been disabled"
        case .invalidEmail:                         return "Invalid email address"
        case .tooManyRequests:                      return "Too many attempts. Please try again later"
        case .networkError:                         return "Network error. Please check your connection and try again"
        case .emailAlreadyInUse:                    return "This email is already in use"
        case .weakPassword:                         return "Password is too weak"
        default:                                    return "Something went wrong"
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
        case .emptyEmail:           return "Please enter your email"
        case .invalidEmail:         return "Invalid email address"
        case .emptyPassword:        return "Please enter your password"
        case .passwordTooShort:     return "Password must be at least 6 characters"
        case .emptyConfirmPassword: return "Please confirm your password"
        case .passwordMismatch:     return "Passwords do not match"
        case .firebase(let code):   return code.registerMessage
        case .unknown(let msg):     return msg
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
        case .emailAlreadyInUse:    return "This email is already in use"
        case .invalidEmail:         return "Invalid email address"
        case .weakPassword:         return "Password is too weak. Please choose a stronger password"
        case .networkError:         return "Network error. Please check your connection and try again"
        default:                    return "Something went wrong"
        }
    }
}
