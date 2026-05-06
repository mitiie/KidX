//
//  FlashCardDetailViewModel.swift
//  KidX
//
//  Created by 𝙢𝙩 on 7/5/26.
//

import Foundation

class FlashCardDetailViewModel {
    private(set) var itemList: [FlashCardItem]
    let categoryName: String
    let isRelearnMode: Bool
    let relearnType: RelearnType?

    private(set) var currentIndex: Int = 0
    private(set) var rememberCount: Int = 0
    private(set) var dontRememberCount: Int = 0

    init(items: [FlashCardItem], category: String, isRelearnMode: Bool = false, relearnType: RelearnType? = nil) {
        self.itemList = items
        self.categoryName = category
        self.isRelearnMode = isRelearnMode
        self.relearnType = relearnType
    }

    var currentItem: FlashCardItem? {
        guard currentIndex >= 0 && currentIndex < itemList.count else { return nil }
        return itemList[currentIndex]
    }

    var progressText: String {
        return "\(currentIndex + 1)/\(itemList.count)"
    }

    var progress: Float {
        return Float(currentIndex + 1) / Float(itemList.count)
    }

    var isFirstCard: Bool {
        return currentIndex == 0
    }

    var isLastCard: Bool {
        return currentIndex >= itemList.count - 1
    }

    var hasMoreCards: Bool {
        return currentIndex < itemList.count - 1
    }

    func markAsRemembered() -> Bool {
        guard currentIndex < itemList.count else { return false }
        itemList[currentIndex].isRemembered = true
        rememberCount += 1
        return moveToNextCard()
    }

    func markAsNotRemembered() -> Bool {
        guard currentIndex < itemList.count else { return false }
        itemList[currentIndex].isRemembered = false
        dontRememberCount += 1
        return moveToNextCard()
    }

    func moveToNextCard() -> Bool {
        if hasMoreCards {
            currentIndex += 1
            return false // Not reached the end
        }
        return true // Reached the end
    }

    func moveToPreviousCard() -> Bool {
        if currentIndex > 0 {
            currentIndex -= 1
            return true
        }
        return false
    }

    func createSummaryViewModel() -> SummaryViewModel {
        return SummaryViewModel(
            total: itemList.count,
            remembered: rememberCount,
            notRemembered: dontRememberCount,
            items: itemList
        )
    }
}
