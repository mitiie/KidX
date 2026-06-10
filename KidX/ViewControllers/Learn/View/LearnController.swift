//
//  LearnController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 26/3/26.
//

import UIKit

class LearnController: BaseController {
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heroTitleLabel: UILabel!
    
    // Card 1: Luyện Viết Chữ Số
    @IBOutlet weak var writingPracticeCardView: UIView!
    @IBOutlet weak var wpIconContainerView: UIView!
    @IBOutlet weak var writingPracticeBadgeLabel: UILabel!
    @IBOutlet weak var writingPracticeTitleLabel: UILabel!
    @IBOutlet weak var writingPracticeDescLabel: UILabel!
    @IBOutlet weak var writingPracticeButton: UIButton!
    
    // Card 2: Phép Tính Vui Nhộn
    @IBOutlet weak var mathProblemsCardView: UIView!
    @IBOutlet weak var mpIconContainerView: UIView!
    @IBOutlet weak var mpBadgeView: UIView!
    @IBOutlet weak var mathProblemsTitleLabel: UILabel!
    @IBOutlet weak var mathProblemsDescLabel: UILabel!
    @IBOutlet weak var mathProblemsButton: UIButton!
    
    // Card 3: Thử Thách Hôm Nay
    @IBOutlet weak var challengeSectionTitleLabel: UILabel!
    @IBOutlet weak var challengeRewardButton: UIButton!
    @IBOutlet weak var challengeCardView: UIView!
    @IBOutlet weak var chIconContainerView: UIView!
    @IBOutlet weak var challengeTimeLabel: UILabel!
    @IBOutlet weak var challengeDescLabel: UILabel!
    @IBOutlet weak var challengeProgressBar: UIProgressView!
    @IBOutlet weak var challengeProgressLabel: UILabel!
    @IBOutlet weak var challengeButton: UIButton!

    // MARK: - ViewModel
    private let viewModel: LearnViewModel

    init(viewModel: LearnViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Make decoration views perfectly circular after layouts are calculated
        wpIconContainerView.layer.cornerRadius = wpIconContainerView.frame.height / 2
        writingPracticeBadgeLabel.layer.cornerRadius = writingPracticeBadgeLabel.frame.height / 2
        mpIconContainerView.layer.cornerRadius = mpIconContainerView.frame.height / 2
        mpBadgeView.layer.cornerRadius = mpBadgeView.frame.height / 2
        chIconContainerView.layer.cornerRadius = chIconContainerView.frame.height / 2
        challengeButton.layer.cornerRadius = challengeButton.frame.height / 2
    }

    // MARK: - Setup UI (gọi bởi BaseController.viewDidLoad)
    override func setupUI() {
        // Hide base background image, set custom light blue-grey background
        view.backgroundColor = UIColor(hex: 0xF4F6FF)
        for subview in view.subviews {
            if let imageView = subview as? UIImageView, imageView.image == UIImage(resource: .icBg) {
                imageView.isHidden = true
            }
        }
        
        // Prevent tab bar from blocking the bottom content
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(AppConfiguration.HEIGHT_TABBAR) + 16.0, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
        setupMainLabels()
        setupMainCards()
    }

    private func setupMainLabels() {
        heroTitleLabel.text = "Cùng khám phá\nthế giới con số"
        heroTitleLabel.font = UIFont.custom(28, .semiBold)
        heroTitleLabel.textColor = AppColor.text.color
        heroTitleLabel.numberOfLines = 2
        
        challengeSectionTitleLabel.text = "Thử Thách Hôm Nay"
        challengeSectionTitleLabel.font = UIFont.custom(20, .semiBold)
        challengeSectionTitleLabel.textColor = AppColor.text.color
        
        challengeRewardButton.setTitle("Xem tất cả", for: .normal)
        challengeRewardButton.setTitleColor(AppColor.primary.color, for: .normal)
        challengeRewardButton.titleLabel?.font = UIFont.custom(14, .semiBold)
    }

    private func setupMainCards() {
        // Card 1: Luyện Viết Chữ Số (White card)
        writingPracticeCardView.backgroundColor = .white
        styleCardView(writingPracticeCardView)
        
        wpIconContainerView.backgroundColor = UIColor(hex: 0xE6F0FF)
        wpIconContainerView.clipsToBounds = true
        
        writingPracticeBadgeLabel.text = "123"
        writingPracticeBadgeLabel.font = UIFont.custom(10, .semiBold)
        writingPracticeBadgeLabel.textColor = .white
        writingPracticeBadgeLabel.backgroundColor = UIColor(hex: 0xFF8800)
        writingPracticeBadgeLabel.textAlignment = .center
        writingPracticeBadgeLabel.clipsToBounds = true
        
        writingPracticeTitleLabel.text = "Luyện Viết Chữ Số"
        writingPracticeTitleLabel.font = UIFont.custom(20, .semiBold)
        writingPracticeTitleLabel.textColor = AppColor.text.color
        
        writingPracticeDescLabel.text = "Tập viết các con số từ 0 đến 9 thật xinh xắn cùng bạn Bút Chì."
        writingPracticeDescLabel.font = UIFont.custom(14, .regular)
        writingPracticeDescLabel.textColor = AppColor.grey.color
        writingPracticeDescLabel.numberOfLines = 0
        
        styleTextLinkButton(writingPracticeButton, title: "Bắt đầu ngay", color: AppColor.primary.color)
        
        // Card 2: Phép Tính Vui Nhộn (Yellow card)
        mathProblemsCardView.backgroundColor = UIColor(hex: 0xFFCC00)
        styleCardView(mathProblemsCardView)
        
        mpIconContainerView.backgroundColor = UIColor(hex: 0xFFE680)
        mpIconContainerView.clipsToBounds = true
        
        mpBadgeView.backgroundColor = UIColor(hex: 0x0055B3)
        mpBadgeView.clipsToBounds = true
        
        mathProblemsTitleLabel.text = "Phép Tính Vui Nhộn"
        mathProblemsTitleLabel.font = UIFont.custom(20, .semiBold)
        mathProblemsTitleLabel.textColor = AppColor.text.color
        
        mathProblemsDescLabel.text = "Thử thách cộng trừ siêu tốc cùng các bạn thú rừng xanh."
        mathProblemsDescLabel.font = UIFont.custom(14, .regular)
        mathProblemsDescLabel.textColor = AppColor.text.color.withAlphaComponent(0.8)
        mathProblemsDescLabel.numberOfLines = 0
        
        styleTextLinkButton(mathProblemsButton, title: "Chơi ngay nào", color: AppColor.text.color)
        
        // Card 3: Thử Thách Hôm Nay (Light blue/purple card)
        challengeCardView.backgroundColor = UIColor(hex: 0xEEF2FF)
        styleCardView(challengeCardView)
        
        chIconContainerView.backgroundColor = .white
        chIconContainerView.clipsToBounds = true
        
        challengeTimeLabel.text = "CÒN 2 GIỜ NỮA"
        challengeTimeLabel.font = UIFont.custom(10, .semiBold)
        challengeTimeLabel.textColor = UIColor(hex: 0xD97706) // Brown/orange
        challengeTimeLabel.backgroundColor = UIColor(hex: 0xFEF3C7)
        challengeTimeLabel.layer.cornerRadius = 6
        challengeTimeLabel.clipsToBounds = true
        
        challengeDescLabel.text = "Giải 10 phép tính cộng trong 1 phút!"
        challengeDescLabel.font = UIFont.custom(16, .semiBold)
        challengeDescLabel.textColor = AppColor.text.color
        challengeDescLabel.numberOfLines = 0
        
        challengeProgressLabel.text = "Đã hoàn thành 7/10"
        challengeProgressLabel.font = UIFont.custom(12, .medium)
        challengeProgressLabel.textColor = AppColor.grey.color
        
        challengeProgressBar.progress = 0.7
        challengeProgressBar.progressTintColor = UIColor(hex: 0xFF8800) // Orange progress bar
        challengeProgressBar.trackTintColor = UIColor(hex: 0xE0E7FF)
        challengeProgressBar.layer.cornerRadius = 4
        challengeProgressBar.clipsToBounds = true
        
        // Circular play button
        challengeButton.backgroundColor = AppColor.text.color
        challengeButton.tintColor = .white
        challengeButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        challengeButton.layer.shadowColor = AppColor.text.color.cgColor
        challengeButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        challengeButton.layer.shadowOpacity = 0.2
        challengeButton.layer.shadowRadius = 6
    }
    
    private func styleCardView(_ cardView: UIView) {
        cardView.layer.cornerRadius = 24
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 8)
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowRadius = 16
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.1).cgColor
    }
    
    private func styleTextLinkButton(_ button: UIButton, title: String, color: UIColor) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = UIFont.custom(16, .semiBold)
        button.backgroundColor = .clear
        
        // Add arrow symbol on the right
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let arrowImage = UIImage(systemName: "arrow.right", withConfiguration: config)
        button.setImage(arrowImage, for: .normal)
        button.tintColor = color
        
        // Spacing and position
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .leading
    }

    // MARK: - IBActions
    @IBAction func writingPracticeTapped(_ sender: UIButton) {
        viewModel.navigateToWritingPractice()
    }
    
    @IBAction func mathProblemsTapped(_ sender: UIButton) {
        showAlertPlaceholder(title: "Phép Tính Vui Nhộn")
    }
    
    @IBAction func challengeTapped(_ sender: UIButton) {
        showAlertPlaceholder(title: "Thử Thách Hôm Nay")
    }
    
    @IBAction func challengeRewardTapped(_ sender: UIButton) {
        showAlertPlaceholder(title: "Xem Tất Cả")
    }
    
    private func showAlertPlaceholder(title: String) {
        let alert = UIAlertController(
            title: title,
            message: "Tính năng này sẽ được cập nhật trong các bài học tiếp theo!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default))
        present(alert, animated: true)
    }
}
