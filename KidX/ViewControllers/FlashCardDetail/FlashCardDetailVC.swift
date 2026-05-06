//
//  FlashCardDetailVC.swift
//  MV_2570
//
//  Created by Bui Minh Tien on 30/6/25.
//

import UIKit

enum RelearnType {
    case remembered
    case notRemembered
}

class FlashCardDetailVC: BaseController {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var flashCardLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var backGroundIMG: UIImageView!
    @IBOutlet weak var noteIMG: UIImageView!
    @IBOutlet weak var markIMG: UIImageView!
    @IBOutlet weak var rememberLabel: UILabel!
    @IBOutlet weak var rememberCount: UILabel!
    @IBOutlet weak var dontRememberLabel: UILabel!
    @IBOutlet weak var dontRememberCount: UILabel!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var btnFlip: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var errorIMG: UIImageView!
    @IBOutlet weak var correctIMG: UIImageView!
    @IBOutlet weak var rememState: UIImageView!

    private let viewModel: FlashCardDetailViewModel
    private var isFlipped = false

    init(viewModel: FlashCardDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMode()
        showCurrentCard()
    }

    override func setupUI() {
        flashCardLabel.text = viewModel.categoryName
        [flashCardLabel, progressLabel, rememberCount, dontRememberCount, cardName].forEach {
            $0?.font = UIFont.custom(20, .semiBold)
        }

        descriptionLabel.font = UIFont.custom(20, .regular)
        progressBar.transform = CGAffineTransform(scaleX: 1, y: 3)

        btnNext.isHidden = !viewModel.isRelearnMode
        btnPrevious.isHidden = !viewModel.isRelearnMode
        rememState.isHidden = !viewModel.isRelearnMode

        errorIMG.isHidden = viewModel.isRelearnMode
        correctIMG.isHidden = viewModel.isRelearnMode
        rememberCount.isHidden = viewModel.isRelearnMode
        dontRememberCount.isHidden = viewModel.isRelearnMode
        rememberLabel.isHidden = viewModel.isRelearnMode
        dontRememberLabel.isHidden = viewModel.isRelearnMode
    }

    private func setupMode() {
        if viewModel.isRelearnMode {
            rememState.image = UIImage(resource: .icRemember)
        } else {
            setupSwipeGestures()
        }
    }

    private func setupSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right

        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(swipeLeft)
        containerView.addGestureRecognizer(swipeRight)
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            markAsRemembered()
        case .right:
            markAsNotRemembered()
        default: break
        }
    }

    private func markAsRemembered() {
        UIView.animate(withDuration: 0.5, animations: {
            self.backGroundIMG.image = UIImage(resource: .rememberBG)
            self.containerView.transform = CGAffineTransform(translationX: -300, y: 1000).rotated(by: -.pi / 2)
        }) { _ in
            let isLast = self.viewModel.markAsRemembered()
            self.incrementRemember()
            self.handleNextCard(isLast: isLast)
        }
    }

    private func markAsNotRemembered() {
        UIView.animate(withDuration: 0.5, animations: {
            self.backGroundIMG.image = UIImage(resource: .dontRememberBG)
            self.containerView.transform = CGAffineTransform(translationX: 300, y: 1000).rotated(by: .pi / 2)
        }) { _ in
            let isLast = self.viewModel.markAsNotRemembered()
            self.incrementDontRemember()
            self.handleNextCard(isLast: isLast)
        }
    }

    private func incrementRemember() {
        rememberCount.text = "\(viewModel.rememberCount)"
        resetCard()
    }

    private func incrementDontRemember() {
        dontRememberCount.text = "\(viewModel.dontRememberCount)"
        resetCard()
    }

    private func resetCard() {
        UIView.animate(withDuration: 0.2) {
            self.backGroundIMG.image = UIImage(resource: .cardDetailBG)
            self.noteIMG.transform = .identity
            self.containerView.transform = .identity
        }
    }

    private func handleNextCard(isLast: Bool) {
        if isLast {
            let summaryVM = viewModel.createSummaryViewModel()
            let summaryVC = SummaryVC(viewModel: summaryVM)
            navigationController?.pushViewController(summaryVC, animated: true)
            return
        }

        UIView.animate(withDuration: 0.2) {
            self.containerView.transform = .identity
        }
        showCurrentCard()
    }

    private func showCurrentCard() {
        guard let item = viewModel.currentItem else { return }

        cardName.text = item.title
        descriptionLabel.text = item.description
        noteIMG.image = loadImage(from: item.imageName)
        markIMG.image = item.isRemembered ? UIImage(resource: .starSelected) : UIImage(resource: .starUnselected)

        descriptionLabel.alpha = 0
        noteIMG.alpha = 1
        isFlipped = false
        containerView.transform = .identity

        progressLabel.text = viewModel.progressText
        progressBar.setProgress(viewModel.progress, animated: true)
    }

    private func loadImage(from path: String?) -> UIImage? {
        guard let path = path, !path.isEmpty else { return nil }

        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = docDir.appendingPathComponent(path).path

        return UIImage(contentsOfFile: filePath) ?? UIImage(named: path)
    }

    @IBAction func btnFlipTapped(_ sender: UIButton) {
        isFlipped.toggle()
        guard let currentItem = viewModel.currentItem else { return }

        if isFlipped {
            UIView.transition(with: noteIMG, duration: 0.3, options: .transitionFlipFromRight) {
                self.noteIMG.alpha = 0
            }
            UIView.transition(with: descriptionLabel, duration: 0.3, options: .transitionFlipFromRight) {
                self.descriptionLabel.text = currentItem.description
                self.descriptionLabel.alpha = 1
            }
        } else {
            UIView.transition(with: descriptionLabel, duration: 0.3, options: .transitionFlipFromLeft) {
                self.descriptionLabel.alpha = 0
            }
            UIView.transition(with: noteIMG, duration: 0.3, options: .transitionFlipFromLeft) {
                self.noteIMG.alpha = 1
            }
        }
    }

    @IBAction func btnNextTapped(_ sender: UIButton) {
        if viewModel.isRelearnMode {
            let isLast = viewModel.moveToNextCard()
            handleNextCard(isLast: isLast)
        }
    }

    @IBAction func btnPreviousTapped(_ sender: UIButton) {
        if viewModel.moveToPreviousCard() {
            UIView.animate(withDuration: 0.2) {
                self.containerView.transform = .identity
            }
            showCurrentCard()
        }
    }

    @IBAction func btnBackTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
