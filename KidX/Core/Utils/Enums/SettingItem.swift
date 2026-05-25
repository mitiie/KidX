//
//  SettingItem.swift
//  KidX
//
//  Created by 𝙢𝙩 on 20/4/26.
//

enum SettingItem: CaseIterable {
    case language, update, rate, feedback, privacyPolicy, term

    var title: String {
        switch self {
        case .language:      return "Language".localize()
        case .update:      return "New Update Available".localize()
        case .feedback:    return "Feedback".localize()
        case .rate:        return "Rate us".localize()
        case .term:        return "Term of service".localize()
        case .privacyPolicy: return "Privacy policy".localize()
        }
    }

    var iconName: String {
        switch self {
        case .language:      return "ic-setting-language"
        case .update:      return "ic-setting-update"
        case .feedback:      return "ic-setting-feedback"
        case .rate:        return "ic-setting-rate"
        case .term:      return "ic-setting-term"
        case .privacyPolicy: return "ic-setting-policy"
        }
    }
}
