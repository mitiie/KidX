//
//  HomeViewModel.swift
//  KidX
//
//  Created by 𝙢𝙩 on 5/4/26.
//

import FirebaseAuth
import GoogleSignIn

final class HomeViewModel {

    private(set) var popularCategories: [PopularFlashCardCategory] = []
    private(set) var basicCategories: [BasicFlashCardCategory] = []
    private(set) var statsSummary: AchievementStatsSummary = AchievementStatsService.shared.loadSnapshot().summary
    private(set) var itemList: [FlashCardItem] = []
    private(set) var titleText: String = ""

    private let navigation: NavigationState<MainRoute>

    init(navigation: NavigationState<MainRoute>) {
        self.navigation = navigation
    }

    func loadData() {
        popularCategories = PopularFlashCardService.loadCategories()
        basicCategories = BasicFlashCardService.loadCategories()
        statsSummary = AchievementStatsService.shared.loadSnapshot().summary
    }

    func selectCategory(_ category: PopularFlashCardCategory) {
        self.itemList = category.items
        self.titleText = category.category
    }

    func getUnrememberedItems() -> [FlashCardItem] {
        return itemList.filter { !$0.isRemembered }
    }

    func getRandomizedItems() -> [FlashCardItem] {
        return itemList.shuffled()
    }

    func reorderItems(at index: Int) -> [FlashCardItem] {
        var reordered = itemList
        let selected = reordered.remove(at: index)
        reordered.insert(selected, at: 0)
        return reordered
    }

    func logout(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            print("✅ Logout successful")
            completion(nil)
        } catch {
            print("❌ Logout failed: \(error.localizedDescription)")
            completion(error)
        }
    }

    func navigateToLogin() {
        navigation.push(.logout)
    }

    func navigateToListFlashCard(category: PopularFlashCardCategory) {
        navigation.push(.listFlashCard(category))
    }

    func navigateToListFlashCardBasic(category: BasicFlashCardCategory) {
        navigation.push(.listFlashCardBasic(category))
    }

    func navigateToAchieve() {
        navigation.push(.achieve)
    }

    func navigateToFlashCardDetail(items: [FlashCardItem], category: String) {
        let input = FlashCardDetailRouteInput(
            items: items,
            category: category,
            isRelearnMode: false,
            relearnType: nil
        )
        navigation.push(.flashCardDetail(input))
    }

    func navigateBack() {
        navigation.pop()
    }
}
