//
//  TabBarItem.swift
//  MV_2617
//
//  Created by 𝙢𝙩 on 26/1/26.
//

import UIKit

enum TabBarItem: String, CaseIterable {
    case home, game, list, setting
    
    var index: Int { Self.allCases.firstIndex(of: self) ?? 0 }
    
    func image(isSelected: Bool) -> UIImage? {
        return UIImage(named: "ic-\(rawValue)\(isSelected ? "-selected" : "")")
    }
    
    func viewController() -> UIViewController {
        switch self {
        case .game: return GameController()
        case .home: return HomeController()
        case .list: return ListController()
        case .setting: return SettingController()
        }
    }
}
