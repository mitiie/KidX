//
//  PopularFlashCard.swift
//  KidX
//
//  Created by 𝙢𝙩 on 27/4/26.
//

import UIKit

struct PopularFlashCardCategory: Codable {
    let categoryVi: String
    let categoryEn: String
    let imageName: String
    let items: [FlashCardItem]

    var category: String {
        LocalizeHelper.shared.isVietnameseSelected ? categoryVi : categoryEn
    }
}

struct FlashCardItem: Codable, Equatable {
    let titleVi: String
    let titleEn: String
    let imageName: String
    let descriptionVi: String
    let descriptionEn: String

    var title: String {
        LocalizeHelper.shared.isVietnameseSelected ? titleVi : titleEn
    }

    var description: String {
        LocalizeHelper.shared.isVietnameseSelected ? descriptionVi : descriptionEn
    }
}

struct BasicFlashCardCategory: Codable {
    let id: String
    let titleVi: String
    let titleEn: String
    let descriptionVi: String
    let descriptionEn: String
    let items: [BasicFlashCardItem]
}

struct BasicFlashCardItem: Codable, Equatable {
    let vietnameseText: String
    let englishText: String
    let imageFilename: String?
}

extension FlashCardItem {
    var isRemembered: Bool {
        get {
            UserDefaults.standard.bool(forKey: "remember_\(title)")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "remember_\(title)")
        }
    }
}
