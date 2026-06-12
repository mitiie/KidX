//
//  GradientView.swift
//  KidX
//
//  Created by 𝙢𝙩 on 22/5/26.
//

import UIKit

enum GradientDirection {
    case horizontal //Default: left to right.
    case vertical //Default: top to bottom
    case topLeftToRightBottom
    case bottomLeftToTopRight

    var startPoint: CGPoint {
        switch self {
        case .horizontal:
            return CGPoint(x: 0, y: 0)
        case .vertical:
            return CGPoint(x: 0, y: 0)
        case .topLeftToRightBottom:
            return CGPoint(x: 0, y: 0)
        case .bottomLeftToTopRight:
            return CGPoint(x: 0, y: 1)
        }
    }

    var endPoint: CGPoint {
        switch self {
        case .horizontal:
            return CGPoint(x: 1, y: 0)
        case .vertical:
            return CGPoint(x: 0, y: 1)
        case .topLeftToRightBottom:
            return CGPoint(x: 1, y: 1)
        case .bottomLeftToTopRight:
            return CGPoint(x: 1, y: 0)
        }
    }

}

class GradientView: UIView {

    var direction: GradientDirection = .vertical
    var colors: [CGColor] = [] {
        didSet {
            self.addGradient(colors, direction.startPoint, direction.endPoint, cornerRadius: radius)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.addGradient(colors, direction.startPoint, direction.endPoint, cornerRadius: radius)
    }

    func setup(_ direction: GradientDirection, _ colors: [CGColor]) {
        self.direction = direction
        self.colors = colors
    }

}
