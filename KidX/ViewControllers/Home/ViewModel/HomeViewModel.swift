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
    private(set) var itemList: [FlashCardItem] = []
    private(set) var titleText: String = ""

    private let navigation: NavigationState<HomeRoute>

    init(navigation: NavigationState<HomeRoute>) {
        self.navigation = navigation
    }

    func loadData() {
        popularCategories = PopularFlashCardService.loadCategories()
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
}
