//
//  ListFlashCardBasicViewModel.swift
//  KidX
//
//  Created by mt on 13/6/26.
//

import Foundation

final class ListFlashCardBasicViewModel {
    let category: BasicFlashCardCategory

    private let navigation: NavigationState<MainRoute>

    init(navigation: NavigationState<MainRoute>, category: BasicFlashCardCategory) {
        self.navigation = navigation
        self.category = category
    }

    var titleText: String {
        "\(category.titleVi) / \(category.titleEn)"
    }

    var subtitleText: String {
        "\(category.descriptionVi)\n\(category.descriptionEn)"
    }

    var items: [BasicFlashCardItem] {
        category.items
    }

    func navigateBack() {
        navigation.pop()
    }
}
