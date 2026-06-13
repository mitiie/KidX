//
//  AppRoute.swift
//  KidX
//
//  Created by 𝙢𝙩 on 5/4/26.
//


// MARK: - Route
enum AuthRoute {
    case splash
    case login
    case register
    case main
}

struct FlashCardDetailRouteInput {
    let items: [FlashCardItem]
    let category: String
    let isRelearnMode: Bool
    let relearnType: RelearnType?
}

struct SummaryRouteInput {
    let total: Int
    let remembered: Int
    let notRemembered: Int
    let items: [FlashCardItem]
}

enum MainRoute {
    case discovery
    case learn
    case home
    case achieve
    case profile
    case listFlashCard(PopularFlashCardCategory)
    case listFlashCardBasic(BasicFlashCardCategory)
    case flashCardDetail(FlashCardDetailRouteInput)
    case summary(SummaryRouteInput)
    case logout
    case language(ProfileViewModel)
    case writingPractice(LearnViewModel)
    case listAlphabet
    case drawLetter(AlphabetLetter)
    case listGame(ListGameViewModel)
    case caculate(CaculateViewModel)
}
