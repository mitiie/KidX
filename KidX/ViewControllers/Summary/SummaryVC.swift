//
//  SummaryVC.swift
//  MV_2570
//
//  Created by Bui Minh Tien on 1/7/25.
//

import UIKit

class SummaryVC: BaseController {
    @IBOutlet weak var rememberLabel: UILabel!
    @IBOutlet weak var rememberCount: UILabel!
    @IBOutlet weak var dontRememberLabel: UILabel!
    @IBOutlet weak var dontRememberCount: UILabel!
    
    @IBOutlet weak var relearnRememberView: UIView!
    @IBOutlet weak var relearnRememberLabel: UILabel!
    @IBOutlet weak var relearnDontRememberView: UIView!
    @IBOutlet weak var relearnDontRememLabel: UILabel!
    @IBOutlet weak var backToHomeView: UIView!
    @IBOutlet weak var backToHomeLabel: UILabel!

    private let viewModel: SummaryViewModel

    init(viewModel: SummaryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizers()
    }

    override func setupUI() {
        [rememberLabel, rememberCount, dontRememberLabel, dontRememberCount].forEach {
            $0?.font = UIFont.custom(20, .semiBold)
        }

        [relearnRememberLabel, relearnDontRememLabel, backToHomeLabel].forEach {
            $0?.font = UIFont.custom(17, .regular)
        }

        rememberCount.text = viewModel.rememberedText
        dontRememberCount.text = viewModel.notRememberedText
    }

    private func setupGestureRecognizers() {
        addTap(to: backToHomeView, action: #selector(handleBackToHome))
        addTap(to: relearnRememberView, action: #selector(handleRelearnRemembered))
        addTap(to: relearnDontRememberView, action: #selector(handleRelearnDontRemembered))
    }

    private func addTap(to view: UIView, action: Selector) {
        let tap = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }

    @objc private func handleBackToHome() {
        addTapBounceEffect(to: backToHomeView) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    @objc private func handleRelearnRemembered() {
        addTapBounceEffect(to: relearnRememberView) {
            self.startRelearn(type: .remembered)
        }
    }

    @objc private func handleRelearnDontRemembered() {
        addTapBounceEffect(to: relearnDontRememberView) {
            self.startRelearn(type: .notRemembered)
        }
    }

    private func startRelearn(type: RelearnType) {
        guard let detailVM = viewModel.createRelearnViewModel(type: type) else {
            let alert = UIAlertController(title: "Notice", message: "There are no cards to review.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let vc = FlashCardDetailVC(viewModel: detailVM)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func addTapBounceEffect(to view: UIView, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, animations: {
            view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                view.transform = .identity
            }, completion: { _ in
                completion()
            })
        }
    }
}
