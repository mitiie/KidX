//
//  DiscoveryController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 26/3/26.
//

import UIKit

class DiscoveryController: BaseController {
    private let viewModel: DiscoveryViewModel

    init(viewModel: DiscoveryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btnAddNewTapped(_ sender: Any) {
        viewModel.importPhoto(from: view)
    }
}
