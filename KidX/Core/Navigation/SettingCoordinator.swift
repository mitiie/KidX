//
//  SettingCoordinator.swift
//  KidX
//
//  Created by 𝙢𝙩 on 6/4/26.
//

final class SettingCoordinator: NavigationStateDelegate {
    
    typealias Route = SettingRoute
    
    private let authNavigation: NavigationState<AuthRoute>
    
    init(authNavigation: NavigationState<AuthRoute>) {
        self.authNavigation = authNavigation
    }
    
    func onPush(_ route: SettingRoute, isReplaceTop: Bool, animated: Bool) {
        switch route {
        case .logout:
            authNavigation.push(.login, isReplaceTop: true)
        }
    }
    
    func onPop(_ index: Int, animated: Bool) {}
    func onPresent(_ route: SettingRoute, animated: Bool) {}
    func onDismiss(animated: Bool) {}
}
