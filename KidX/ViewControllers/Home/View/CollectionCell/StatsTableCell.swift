//
//  StatsTableCell.swift
//  KidX
//
//  Created by 𝙢𝙩 on 13/6/26.
//

import UIKit

protocol StatsTableCellDelegate: AnyObject {
    func statsTableCellDidTap(_ cell: StatsTableCell)
}

final class StatsTableCell: UITableViewCell {
    @IBOutlet private weak var cardView: GradientView!
    @IBOutlet private weak var levelPillView: UIView!
    @IBOutlet private weak var levelLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var trophyContainerView: UIView!
    @IBOutlet private weak var trophyImageView: UIImageView!
    @IBOutlet private weak var progressView: GradientProgressView!

    weak var delegate: StatsTableCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func configure(with summary: AchievementStatsSummary) {
        levelLabel.text = String(format: "Level %d".localize(), summary.level)
        subtitleLabel.text = summary.completedChallengesText
        progressView.setProgress(CGFloat(summary.weeklyCompletionPercent) / 100, duration: 0.8)
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        cardView.radius = 36
        cardView.setup(.topLeftToRightBottom, [
            UIColor(hex: 0x006095).cgColor,
            UIColor(hex: 0x35ADFF).cgColor
        ])
        cardView.addShadow(color: UIColor(hex: 0x006095), opacity: 0.18, offset: CGSize(width: 0, height: 10), radius: 18)

        levelPillView.layer.cornerRadius = 14
        trophyContainerView.layer.cornerRadius = 30
        trophyContainerView.transform = CGAffineTransform(rotationAngle: 0.08)

        titleLabel.font = UIFont.custom(29, .semiBold)
        subtitleLabel.font = UIFont.custom(15, .semiBold)
        levelLabel.font = UIFont.custom(13, .semiBold)

        trophyImageView.image = UIImage(systemName: "trophy.fill")
        trophyImageView.tintColor = UIColor(hex: 0x4F3900)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleStatsCardTap))
        cardView.addGestureRecognizer(tap)
        cardView.isUserInteractionEnabled = true
    }

    @objc private func handleStatsCardTap() {
        UIView.animate(withDuration: 0.12, animations: {
            self.cardView.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { _ in
            UIView.animate(withDuration: 0.18, animations: {
                self.cardView.transform = .identity
            }) { _ in
                self.delegate?.statsTableCellDidTap(self)
            }
        }
    }
}
