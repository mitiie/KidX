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
    private let navigation: NavigationState<MainRoute>
    private let items: [FlashCardItem]

    init(navigation: NavigationState<MainRoute>, total: Int, remembered: Int, notRemembered: Int, items: [FlashCardItem]) {
        self.navigation = navigation
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

    func createRelearnRouteInput(type: RelearnType) -> FlashCardDetailRouteInput? {
        let filteredItems = type == .remembered ? getRememberedItems() : getNotRememberedItems()
        guard !filteredItems.isEmpty else { return nil }
        return FlashCardDetailRouteInput(
            items: filteredItems,
            category: "Review",
            isRelearnMode: true,
            relearnType: type
        )
    }

    func navigateToHome() {
        navigation.popToRoot()
    }

    func navigateToFlashCardDetail(_ input: FlashCardDetailRouteInput) {
        navigation.push(.flashCardDetail(input))
    }
}
