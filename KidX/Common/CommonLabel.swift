//
//  CommonLabel.swift
//  KidX
//
//  Created by 𝙢𝙩 on 31/3/26.
//

import UIKit
import Foundation

class CommonLabel: UILabel {
    @IBInspectable var size: String = FontSize.sm.rawValue {
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
        let _size = FontSize(rawValue: size) ?? .sm
        let _weight = FontWeight(rawValue: weight) ?? .regular
        let _color = AppColor(rawValue: color) ?? .text
        self.font = UIFont.custom(_size, _weight)
        self.textColor = _color.color
    }
}
