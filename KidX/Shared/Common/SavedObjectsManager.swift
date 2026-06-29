//
//  SavedObjectsManager.swift
//  KidX
//
//  Created by 𝙢𝙩 on 6/6/26.
//

import UIKit

struct SavedObjectItem {
    let name: String
    let image: UIImage
    let imageFilename: String
    let dateText: String
}

final class SavedObjectsManager {
    static let shared = SavedObjectsManager()
    
    struct SavedMetadata: Codable {
        let name: String
        let filename: String
        let timestamp: Date
    }
    
    private let metadataKey = "kidx_saved_objects_metadata"
    
    private init() {}
    
    func save(image: UIImage, name: String) {
        let filename = UUID().uuidString + ".jpg"
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: fileURL)
        }
        
        var list = getMetadataList()
        let newItem = SavedMetadata(name: name, filename: filename, timestamp: Date())
        list.insert(newItem, at: 0) // Newest first
        
        if let encoded = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(encoded, forKey: metadataKey)
        }

        AchievementStatsService.shared.recordDiscovery()
        
        // Post a notification to reload the collection view
        NotificationCenter.default.post(name: NSNotification.Name("ReloadSavedObjects"), object: nil)
    }
    
    func loadObjects() -> [SavedObjectItem] {
        let savedMetadataList = getMetadataList()
        
        var items: [SavedObjectItem] = []
        
        // 1. Load user-saved items from disk
        for metadata in savedMetadataList {
            let fileURL = getDocumentsDirectory().appendingPathComponent(metadata.filename)
            if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
                items.append(SavedObjectItem(
                    name: metadata.name,
                    image: image,
                    imageFilename: metadata.filename,
                    dateText: timeAgoString(from: metadata.timestamp)
                ))
            }
        }
        
        // 2. Prepend or append default demo items so they are always visible
        let defaultApple = SavedObjectItem(
            name: "Quả Táo",
            image: UIImage(named: "apple_demo") ?? UIImage(),
            imageFilename: "apple_demo",
            dateText: "Vừa mới tìm thấy"
        )
        let defaultCat = SavedObjectItem(
            name: "Con Mèo",
            image: UIImage(named: "cat_demo") ?? UIImage(),
            imageFilename: "cat_demo",
            dateText: "2 giờ trước"
        )
        
        items.append(defaultApple)
        items.append(defaultCat)
        
        return items
    }

    func savedUserObjectCount() -> Int {
        return getMetadataList().count
    }
    
    private func getMetadataList() -> [SavedMetadata] {
        guard let data = UserDefaults.standard.data(forKey: metadataKey),
              let list = try? JSONDecoder().decode([SavedMetadata].self, from: data) else {
            return []
        }
        return list
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func timeAgoString(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let difference = now.timeIntervalSince(date)
        
        if difference < 60 {
            return "Vừa mới tìm thấy"
        }
        
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return "\(day) ngày trước"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour) giờ trước"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute) phút trước"
        } else {
            return "Vừa mới tìm thấy"
        }
    }
}
