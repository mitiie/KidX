//
//  PopularFlashCard.swift
//  KidX
//
//  Created by 𝙢𝙩 on 27/4/26.
//

import UIKit

struct PopularFlashCardCategory: Codable {
    let category: String
    let imageName: String
    let items: [FlashCardItem]
}

struct FlashCardItem: Codable, Equatable {
    let title: String
    let imageName: String
    let description: String
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
