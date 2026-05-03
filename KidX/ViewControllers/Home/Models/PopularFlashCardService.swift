//
//  PopularFlashCardService.swift
//  KidX
//
//  Created by 𝙢𝙩 on 4/5/26.
//

import UIKit

class PopularFlashCardService {
    static func loadCategories() -> [PopularFlashCardCategory] {
        guard let url = Bundle.main.url(forResource: "PopularFlashCard", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let categories = try? JSONDecoder().decode([PopularFlashCardCategory].self, from: data) else {
            print("Failed to load PopularFlashCard.json")
            return []
        }
        return categories
    }
    
    static func allItems() -> [FlashCardItem] {
        return loadCategories().flatMap { $0.items }
    }
}
