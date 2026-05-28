//
//  DetectResultView.swift
//  KidX
//
//  Created by 𝙢𝙩 on 29/5/26.
//

import UIKit

final class DetectResultView: UIView, XibLoadable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
        setupUI()
    }
    
    private func setupUI() {

    }
}
