//
//  CommonLabel.swift
//  KidX
//
//  Created by 𝙢𝙩 on 31/3/26.
//

import UIKit
import Foundation

class CommonLabel: UILabel {
    @IBInspectable var fontSize: CGFloat = 15.0 {
        didSet { updateStyle() }
    }
    
    @IBInspectable var weight: String = FontWeight.regular.rawValue {
        didSet { updateStyle() }
    }
    
    @IBInspectable var color: String = AppColor.text.rawValue {
        didSet { updateStyle() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateStyle()
    }
    
    func updateStyle() {
        let _weight = FontWeight(rawValue: weight) ?? .regular
        let _color = AppColor(rawValue: color) ?? .primary
        self.font = UIFont.custom(fontSize, _weight)
        self.textColor = _color.color
    }
}
