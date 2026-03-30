//
//  ViewController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 7/2/26.
//

import UIKit

class MainController: UIViewController {
    private var customChildViewController: [UIViewController] = []
    private let tabBar = TabBarView()
    private var currentViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupChildViewControllers()
        displayChildViewController(at: 0)
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
            tabBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
    }

    private func setupChildViewControllers() {
        customChildViewController = TabBarItem.allCases.map { $0.viewController() }
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

// MARK: - TabBarViewDelegate
extension MainController: TabBarViewDelegate {
    func didSelectTab(_ tab: TabBarItem) {
        print("Selected tab: \(tab.rawValue)")
        displayChildViewController(at: tab.index)
    }
}

