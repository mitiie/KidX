//
//  SettingItem.swift
//  KidX
//
//  Created by 𝙢𝙩 on 20/4/26.
//

enum SettingItem: CaseIterable {
    case update, rate, feedback, privacyPolicy, term

    var title: String {
        switch self {
        case .update:      return "Update version"
        case .feedback:    return "Feedback"
        case .rate:        return "Rate 5 stars"
        case .term:        return "Terms of use"
        case .privacyPolicy: return "Privacy policy"
        }
    }

    var iconName: String {
        switch self {
        case .update:      return "ic-setting-update"
        case .feedback:      return "ic-setting-feedback"
        case .rate:        return "ic-setting-rate"
        case .term:      return "ic-setting-term"
        case .privacyPolicy: return "ic-setting-policy"
        }
    }
}
