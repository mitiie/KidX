//
//  Xib+Exts.swift
//  KidX
//
//  Created by 𝙢𝙩 on 7/5/26.
//

import Foundation
import UIKit

protocol XibLoadable {
    static var xibName: String { get }
}

extension XibLoadable where Self: UIViewController {
    static var xibName: String {
        String(describing: self)
    }
}

extension XibLoadable where Self: UIView {
    static var xibName: String {
        String(describing: self)
    }
    
    func loadNibContent() {
        guard let view = Bundle.main.loadNibNamed(Self.xibName, owner: self, options: nil)?.first as? UIView else {
            fatalError("Could not load view from nib with name: \(Self.xibName)")
        }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
}
