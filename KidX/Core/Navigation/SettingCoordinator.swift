//
//  SettingCoordinator.swift
//  KidX
//
//  Created by 𝙢𝙩 on 6/4/26.
//

final class ProfileCoordinator: NavigationStateDelegate {
    
    typealias Route = ProfileRoute
    
    private let authNavigation: NavigationState<AuthRoute>
    
    init(authNavigation: NavigationState<AuthRoute>) {
        self.authNavigation = authNavigation
    }
    
    func onPush(_ route: ProfileRoute, isReplaceTop: Bool, animated: Bool) {
        switch route {
        case .logout:
            authNavigation.push(.login, isReplaceTop: true)
        }
    }
    
    func onPop(_ index: Int, animated: Bool) {}
    func onPresent(_ route: ProfileRoute, animated: Bool) {}
    func onDismiss(animated: Bool) {}
}
