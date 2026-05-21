//
//  MainCoordinator.swift
//  KidX
//
//  Created by 𝙢𝙩 on 5/4/26.
//

import UIKit

final class MainCoordinator: NavigationStateDelegate {

    typealias Route = MainRoute

    private let authNavigation: NavigationState<AuthRoute>
    private let navigationState: NavigationState<MainRoute>
    private weak var rootViewController: UIViewController?

    init(rootViewController: UIViewController, authNavigation: NavigationState<AuthRoute>, navigationState: NavigationState<MainRoute>) {
        self.rootViewController = rootViewController
        self.authNavigation = authNavigation
        self.navigationState = navigationState
    }

    func onPush(_ route: MainRoute, isReplaceTop: Bool, animated: Bool) {
        switch route {
        case .home:
            rootViewController?.navigationController?.popToRootViewController(animated: animated)

        case .listFlashCard(let category):
            push(makeListFlashCardController(category: category), animated: animated)

        case .flashCardDetail(let input):
            push(makeFlashCardDetailController(input: input), animated: animated)

        case .summary(let input):
            push(makeSummaryController(input: input), animated: animated)

        case .logout:
            authNavigation.push(.login, isReplaceTop: true)

        default:
            break
        }
    }

    func onPop(_ index: Int, animated: Bool) {
        if index == 0 {
            rootViewController?.navigationController?.popToRootViewController(animated: animated)
        } else {
            rootViewController?.navigationController?.popViewController(animated: animated)
        }
    }

    func onPresent(_ route: MainRoute, animated: Bool) {}
    func onDismiss(animated: Bool) {}

    private func push(_ viewController: UIViewController, animated: Bool) {
        rootViewController?.navigationController?.pushViewController(viewController, animated: animated)
    }

    private func makeListFlashCardController(category: PopularFlashCardCategory) -> UIViewController {
        let viewModel = makeHomeViewModel()
        viewModel.selectCategory(category)
        return ListFlashCardVC(viewModel: viewModel)
    }

    private func makeFlashCardDetailController(input: FlashCardDetailRouteInput) -> UIViewController {
        return FlashCardDetailVC(viewModel: makeFlashCardDetailViewModel(input: input))
    }

    private func makeSummaryController(input: SummaryRouteInput) -> UIViewController {
        return SummaryVC(viewModel: makeSummaryViewModel(input: input))
    }

    private func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(navigation: navigationState)
    }

    private func makeFlashCardDetailViewModel(input: FlashCardDetailRouteInput) -> FlashCardDetailViewModel {
        return FlashCardDetailViewModel(
            navigation: navigationState,
            items: input.items,
            category: input.category,
            isRelearnMode: input.isRelearnMode,
            relearnType: input.relearnType
        )
    }

    private func makeSummaryViewModel(input: SummaryRouteInput) -> SummaryViewModel {
        return SummaryViewModel(
            navigation: navigationState,
            total: input.total,
            remembered: input.remembered,
            notRemembered: input.notRemembered,
            items: input.items
        )
    }
}
