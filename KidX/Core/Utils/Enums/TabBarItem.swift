//
//  TabBarItem.swift
//  MV_2617
//
//  Created by 𝙢𝙩 on 26/1/26.
//

import UIKit

enum TabBarItem: String, CaseIterable {
    case game, list, home, achieve, profile
    
    var index: Int { Self.allCases.firstIndex(of: self) ?? 0 }
    
    var title: String {
        return rawValue.capitalized
    }
    
    func image(isSelected: Bool) -> UIImage? {
        return UIImage(named: "ic-\(rawValue)\(isSelected ? "-selected" : "")")
    }
}
