//
//  PopularFlashCardService.swift
//  KidX
//
//  Created by 𝙢𝙩 on 4/5/26.
//

import UIKit
import FirebaseDatabase

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

final class BasicFlashCardService {

    /// Cache dữ liệu đã fetch từ Firebase để các lần gọi sau không cần fetch lại
    private static var cachedCategories: [BasicFlashCardCategory]?

    /// Fetch dữ liệu BasicFlashCard từ Firebase Realtime Database (async)
    static func loadCategories(completion: @escaping ([BasicFlashCardCategory]) -> Void) {
        // Trả về cache nếu đã có
        if let cached = cachedCategories {
            completion(cached)
            return
        }

        let ref = Database.database().reference().child("basicFlashCards")
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let rawValue = snapshot.value else {
                print("Firebase basicFlashCards snapshot has no value.")
                completion([])
                return
            }

            var categoryList: [[String: Any]] = []

            if let array = rawValue as? [[String: Any]] {
                categoryList = array
            } else if let array = rawValue as? [Any] {
                categoryList = array.compactMap { $0 as? [String: Any] }
            } else if let dict = rawValue as? [String: [String: Any]] {
                categoryList = Array(dict.values)
            }

            guard !categoryList.isEmpty else {
                print("No basicFlashCards found in Firebase.")
                completion([])
                return
            }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: categoryList, options: [])
                let categories = try JSONDecoder().decode([BasicFlashCardCategory].self, from: jsonData)
                cachedCategories = categories
                completion(categories)
            } catch {
                print("Failed to decode basicFlashCards from Firebase: \(error)")
                completion([])
            }
        } withCancel: { error in
            print("Failed to fetch basicFlashCards: \(error.localizedDescription)")
            completion([])
        }
    }

    /// Xóa cache (ví dụ khi logout hoặc cần refresh)
    static func clearCache() {
        cachedCategories = nil
    }
}

