//
//  SplashController.swift
//  BaseApp
//
//  Created by Tran Van Quang on 8/2/26.
//

import UIKit

class SplashController: BaseController {
    @IBOutlet weak var progressView: GradientProgressView!
    
    private let viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.progress = 0.0
        progressView.setProgress(1.0, duration: 3.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.viewModel.checkAuthAndNavigate()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        progressView.makeCircle()
    }
}
