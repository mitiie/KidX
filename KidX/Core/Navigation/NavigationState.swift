//
//  NavigationState.swift
//  KidX
//
//  Created by 𝙢𝙩 on 5/4/26.
//

import Foundation

protocol NavigationStateDelegate<Route> {
    associatedtype Route
    func onPush(_ route: Route, isReplaceTop: Bool, animated: Bool)
    func onPop(_ index: Int, animated: Bool)
    func onPresent(_ route: Route, animated: Bool)
    func onDismiss(animated: Bool)
}

final class NavigationState<Route: Hashable> {
    
    var routes: [Route] = []
    var delegate: (any NavigationStateDelegate<Route>)?

    init(routes: [Route], delegate: (any NavigationStateDelegate<Route>)? = nil) {
        self.routes = routes
        self.delegate = delegate
    }
    
    func present(_ route: Route, animated: Bool = true) {
        self.delegate?.onPresent(route, animated: animated)
    }
    
    func push(_ route: Route, isReplaceTop: Bool = false, animated: Bool = true) {
        if isReplaceTop { self.routes.removeLast() }
        self.routes.append(route)
        self.delegate?.onPush(route, isReplaceTop: isReplaceTop, animated: animated)
    }
    
    func pop(_ route: Route, animated: Bool = true) {
        guard let index = self.routes.firstIndex(where: { $0 == route }) else { return }
        self.routes = Array(self.routes[0...index])
        self.delegate?.onPop(index, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        self.routes.removeLast()
        guard let route = self.routes.last else { return }
        self.pop(route, animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        while self.routes.count > 1 {
            self.routes.removeLast()
        }
        self.delegate?.onPop(0, animated: animated)
    }
    
    func onDismiss(animated: Bool = true) {
        self.delegate?.onDismiss(animated: animated)
    }
}
