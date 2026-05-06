//
//  SummaryViewModel.swift
//  KidX
//
//  Created by 𝙢𝙩 on 7/5/26.
//

import Foundation

class SummaryViewModel {
    let total: Int
    let remembered: Int
    let notRemembered: Int
    private let items: [FlashCardItem]

    init(total: Int, remembered: Int, notRemembered: Int, items: [FlashCardItem]) {
        self.total = total
        self.remembered = remembered
        self.notRemembered = notRemembered
        self.items = items
    }
    
    var rememberedText: String {
        return "\(remembered)/\(total)"
    }
    
    var notRememberedText: String {
        return "\(notRemembered)/\(total)"
    }

    func getRememberedItems() -> [FlashCardItem] {
        return items.filter { $0.isRemembered }
    }

    func getNotRememberedItems() -> [FlashCardItem] {
        return items.filter { !$0.isRemembered }
    }
    
    func createRelearnViewModel(type: RelearnType) -> FlashCardDetailViewModel? {
        let filteredItems = type == .remembered ? getRememberedItems() : getNotRememberedItems()
        guard !filteredItems.isEmpty else { return nil }
        return FlashCardDetailViewModel(items: filteredItems, category: "Review", isRelearnMode: true, relearnType: type)
    }
}
