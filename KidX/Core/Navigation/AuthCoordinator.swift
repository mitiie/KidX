//
//  AuthCoordinator.swift
//  KidX
//
//  Created by 𝙢𝙩 on 5/4/26.
//

import UIKit

final class AuthCoordinator: NavigationStateDelegate {
    
    typealias Route = AuthRoute
    
    private let navigationController: UINavigationController
    private let navigationState: NavigationState<AuthRoute>
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationState = NavigationState(routes: [.splash])
        self.navigationState.delegate = self
    }
    
    func start() {
        let vc = makeSplashController()
        navigationController.setViewControllers([vc], animated: false)
    }
    
    // MARK: - NavigationStateDelegate
    func onPush(_ route: AuthRoute, isReplaceTop: Bool, animated: Bool) {
        let vc = makeViewController(for: route)
        
        if isReplaceTop {
            var vcs = navigationController.viewControllers
            vcs[vcs.count - 1] = vc
            navigationController.setViewControllers(vcs, animated: animated)
        } else {
            navigationController.pushViewController(vc, animated: animated)
        }
    }
    
    func onPop(_ index: Int, animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    func onPresent(_ route: AuthRoute, animated: Bool) {
        let vc = makeViewController(for: route)
        navigationController.present(vc, animated: animated)
    }
    
    func onDismiss(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }
    
    // MARK: - Factory
    private func makeViewController(for route: AuthRoute) -> UIViewController {
        switch route {
        case .splash:   return makeSplashController()
        case .login:    return makeLoginController()
        case .register: return makeRegisterController()
        case .main:     return makeMainController()
        }
    }
    
    private func makeSplashController() -> UIViewController {
        let vm = SplashViewModel(navigation: navigationState)
        return SplashController(viewModel: vm)
    }
    
    private func makeLoginController() -> UIViewController {
        let vm = LoginViewModel(navigation: navigationState)
        return LoginController(viewModel: vm)
    }
    
    private func makeRegisterController() -> UIViewController {
        let vm = RegisterViewModel(navigation: navigationState)
        return RegisterController(viewModel: vm)
    }
    
    private func makeMainController() -> UIViewController {
        return MainController(authNavigation: navigationState)
    }
}
