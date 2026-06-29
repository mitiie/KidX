//
//  ListAlphabetViewModel.swift
//  KidX
//
//  Created by mt on 14/6/26.
//

import Foundation

final class ListAlphabetViewModel {
    private let navigation: NavigationState<MainRoute>
    let letters = AlphabetLetter.all

    init(navigation: NavigationState<MainRoute>) {
        self.navigation = navigation
    }

    func selectLetter(_ letter: AlphabetLetter) {
        navigation.push(.drawLetter(letter))
    }

    func navigateBack() {
        navigation.pop()
    }
}
