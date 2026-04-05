//
//  HomeCoordinator.swift
//  KidX
//
//  Created by 𝙢𝙩 on 5/4/26.
//

final class HomeCoordinator: NavigationStateDelegate {
    
    typealias Route = HomeRoute
    
    private let authNavigation: NavigationState<AuthRoute>
    
    init(authNavigation: NavigationState<AuthRoute>) {
        self.authNavigation = authNavigation
    }
    
    func onPush(_ route: HomeRoute, isReplaceTop: Bool, animated: Bool) {
        switch route {
        case .logout:
            authNavigation.push(.login, isReplaceTop: true)
        }
    }
    
    func onPop(_ index: Int, animated: Bool) {}
    func onPresent(_ route: HomeRoute, animated: Bool) {}
    func onDismiss(animated: Bool) {}
}
