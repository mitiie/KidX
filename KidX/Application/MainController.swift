//
//  ViewController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 7/2/26.
//

import UIKit

class MainController: UIViewController {
    
    private let authNavigation: NavigationState<AuthRoute>
    private var customChildViewController: [UIViewController] = []
    private let tabBar = TabBarView()
    private var currentViewController: UIViewController?

    init(authNavigation: NavigationState<AuthRoute>) {
        self.authNavigation = authNavigation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupChildViewControllers()
        displayChildViewController(at: 2)
    }
    
    private func setupUI() {
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.delegate = self
        view.addSubview(tabBar)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func setupChildViewControllers() {
        customChildViewController = TabBarItem.allCases.map { makeViewController(for: $0) }
    }
    
    private func makeViewController(for tab: TabBarItem) -> UIViewController {
        switch tab {
        case .home:
            let homeNavigation = NavigationState<HomeRoute>(routes: [])
            homeNavigation.delegate = HomeCoordinator(authNavigation: authNavigation)
            return HomeController(viewModel: HomeViewModel(navigation: homeNavigation))
        case .list:
            return ListController()
        case .game:
            return GameController()
        case .profile:
            let profileNavigation = NavigationState<ProfileRoute>(routes: [])
            profileNavigation.delegate = ProfileCoordinator(authNavigation: authNavigation)
            return ProfileController(viewModel: ProfileViewModel(navigation: profileNavigation))
        case .achieve:
            return AchieveController()
        }
    }
    
    private func displayChildViewController(at index: Int) {
        guard customChildViewController.indices.contains(index) else { return }
        
        if let currentVC = currentViewController {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }
        
        let newVC = customChildViewController[index]
        addChild(newVC)
        view.insertSubview(newVC.view, belowSubview: tabBar)
        newVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            newVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newVC.view.bottomAnchor.constraint(equalTo: tabBar.centerYAnchor)
        ])
        newVC.didMove(toParent: self)
        currentViewController = newVC
    }
}

extension MainController: TabBarViewDelegate {
    func didSelectTab(_ tab: TabBarItem) {
        displayChildViewController(at: tab.index)
    }
}

