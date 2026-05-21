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

final class NavigationState<Route> {

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
        if isReplaceTop, !routes.isEmpty {
            routes.removeLast()
        }
        self.routes.append(route)
        self.delegate?.onPush(route, isReplaceTop: isReplaceTop, animated: animated)
    }

    func pop(animated: Bool = true) {
        guard !routes.isEmpty else { return }
        routes.removeLast()
        delegate?.onPop(routes.count, animated: animated)
    }

    func popToRoot(animated: Bool = true) {
        routes.removeAll()
        delegate?.onPop(0, animated: animated)
    }

    func onDismiss(animated: Bool = true) {
        self.delegate?.onDismiss(animated: animated)
    }
}

extension NavigationState where Route: Equatable {
    func pop(_ route: Route, animated: Bool = true) {
        guard let index = routes.firstIndex(where: { $0 == route }) else { return }
        routes = Array(routes[0...index])
        delegate?.onPop(index, animated: animated)
    }
}
