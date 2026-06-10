//
//  MissionData.swift
//  KidX
//
//  Created by mt on 11/6/26.
//

import Foundation

struct MissionData: Codable {
    let id: String
    let titleEn: String
    let titleVi: String
    let descriptionEn: String
    let descriptionVi: String
    let iconSymbol: String       // SF Symbol name
    let iconBgColorHex: String   // Hex color for the icon background
    let buttonColorHex: String?  // Custom button color (e.g. yellow), nil for gradient
    let keywords: [String]       // English labels predicted by MobileNet to match (lowercase)
    var isCompleted: Bool
    
    var title: String {
        return LocalizeHelper.shared.isVietnameseSelected ? titleVi : titleEn
    }
    
    var description: String {
        return LocalizeHelper.shared.isVietnameseSelected ? descriptionVi : descriptionEn
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case titleEn
        case titleVi
        case descriptionEn
        case descriptionVi
        case iconSymbol
        case iconBgColorHex
        case buttonColorHex
        case keywords
        case isCompleted
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        titleEn = try container.decode(String.self, forKey: .titleEn)
        titleVi = try container.decode(String.self, forKey: .titleVi)
        descriptionEn = try container.decode(String.self, forKey: .descriptionEn)
        descriptionVi = try container.decode(String.self, forKey: .descriptionVi)
        iconSymbol = try container.decode(String.self, forKey: .iconSymbol)
        iconBgColorHex = try container.decode(String.self, forKey: .iconBgColorHex)
        buttonColorHex = try container.decodeIfPresent(String.self, forKey: .buttonColorHex)
        keywords = try container.decode([String].self, forKey: .keywords)
        isCompleted = try container.decodeIfPresent(Bool.self, forKey: .isCompleted) ?? false
    }
    
    static func getCompletedMissionIds() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "completed_missions") ?? []
    }
    
    static func setMissionCompleted(id: String) {
        var completed = getCompletedMissionIds()
        if !completed.contains(id) {
            completed.append(id)
            UserDefaults.standard.set(completed, forKey: "completed_missions")
        }
    }
    
    static func clearProgress() {
        UserDefaults.standard.removeObject(forKey: "completed_missions")
    }
}
