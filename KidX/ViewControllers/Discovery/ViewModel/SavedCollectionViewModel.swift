//
//  SavedCollectionViewModel.swift
//  KidX
//
//  Created by mt on 30/6/26.
//

import Foundation

final class SavedCollectionViewModel {
    private let navigation: NavigationState<MainRoute>
    private(set) var items: [SavedObjectItem] = []
    
    var onDataChanged: (() -> Void)?
    
    init(navigation: NavigationState<MainRoute>) {
        self.navigation = navigation
    }
    
    var titleText: String {
        "Baby's Collection".localize()
    }
    
    var subtitleText: String {
        "Objects discovered by the baby".localize()
    }
    
    func loadData() {
        items = SavedObjectsManager.shared.loadObjects()
        onDataChanged?()
    }
    
    func deleteObject(at index: Int) {
        guard index < items.count else { return }
        let item = items[index]
        SavedObjectsManager.shared.deleteObject(imageFilename: item.imageFilename)
        loadData()
    }
    
    func deleteObjects(at indexes: [Int]) {
        // Sort in descending order to avoid shifts when deleting multiple items
        let sortedIndexes = indexes.sorted(by: >)
        for index in sortedIndexes {
            guard index < items.count else { continue }
            let item = items[index]
            SavedObjectsManager.shared.deleteObject(imageFilename: item.imageFilename)
        }
        loadData()
    }
    
    func navigateBack() {
        navigation.pop()
    }
}
