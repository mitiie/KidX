//
//  DrawLetterViewModel.swift
//  KidX
//
//  Created by mt on 14/6/26.
//

import Foundation

final class DrawLetterViewModel {
    private let navigation: NavigationState<MainRoute>
    let letter: AlphabetLetter

    init(navigation: NavigationState<MainRoute>, letter: AlphabetLetter) {
        self.navigation = navigation
        self.letter = letter
    }

    func navigateBack() {
        navigation.pop()
    }
}
