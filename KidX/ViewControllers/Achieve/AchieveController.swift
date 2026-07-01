//
//  AchieveController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 10/4/26.
//

import UIKit
import DGCharts

final class AchieveController: BaseController {
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var todayButton: UIButton!
    @IBOutlet private weak var weekButton: UIButton!
    @IBOutlet private weak var segmentedContainerView: UIView!

    @IBOutlet private weak var timeCardView: UIView!
    @IBOutlet private weak var starsCardView: UIView!
    @IBOutlet private weak var completionCardView: UIView!
    @IBOutlet private weak var timeValueLabel: UILabel!
    @IBOutlet private weak var starsValueLabel: UILabel!
    @IBOutlet private weak var completionPercentLabel: UILabel!
    @IBOutlet private weak var completionRingView: UIView!

    @IBOutlet private weak var progressEyebrowLabel: UILabel!
    @IBOutlet private weak var weeklyTitleLabel: UILabel!
    @IBOutlet private weak var chartContainerView: UIView!
    @IBOutlet private weak var legendPillView: UIView!

    @IBOutlet private weak var achievementTitleLabel: UILabel!
    @IBOutlet private weak var seeAllButton: UIButton!
    @IBOutlet private var badgeViews: [UIView]!
    @IBOutlet private var badgeIconViews: [UIView]!
    @IBOutlet private var badgeIconImageViews: [UIImageView]!
    @IBOutlet private var badgeTitleLabels: [UILabel]!
    @IBOutlet private var badgeSubtitleLabels: [UILabel]!

    private let viewModel: AchievementStatsViewModel
    private let chartView = BarChartView()
    private let ringTrackLayer = CAShapeLayer()
    private let ringProgressLayer = CAShapeLayer()
    private var currentCompletionPercent: Int = 0

    init(viewModel: AchievementStatsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Common.showLoading()
        viewModel.reload { [weak self] in
            Common.hideLoading()
            self?.render()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCompletionRing(percent: currentCompletionPercent, animated: false)
    }

    override func setupUI() {
        view.backgroundColor = .clear
        setupText()
        setupCards()
        setupChart()
        render()
    }

    private func setupText() {
        titleLabel.font = UIFont.custom(26, .semiBold)
        [todayButton, weekButton].forEach {
            $0?.titleLabel?.font = UIFont.custom(14, .semiBold)
        }

        [timeValueLabel, starsValueLabel, completionPercentLabel].forEach {
            $0?.font = UIFont.custom(24, .semiBold)
        }

        progressEyebrowLabel.font = UIFont.custom(12, .semiBold)
        weeklyTitleLabel.font = UIFont.custom(22, .semiBold)
        achievementTitleLabel.font = UIFont.custom(22, .semiBold)
        seeAllButton.titleLabel?.font = UIFont.custom(13, .semiBold)
    }

    private func setupCards() {
        segmentedContainerView.layer.cornerRadius = 26
        legendPillView.layer.cornerRadius = 20

        [timeCardView, starsCardView, completionCardView, chartContainerView].forEach {
            styleCard($0)
        }

        badgeViews.forEach { styleCard($0, cornerRadius: 28, shadowOpacity: 0.05) }
        badgeIconViews.forEach { $0.layer.cornerRadius = 28 }

        backButton.setImage(UIImage(resource: .icFlcBack), for: .normal)
        backButton.tintColor = AppColor.text.color
    }

    private func setupChart() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartContainerView.addSubview(chartView)
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: chartContainerView.topAnchor, constant: 22),
            chartView.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor, constant: 18),
            chartView.trailingAnchor.constraint(equalTo: chartContainerView.trailingAnchor, constant: -18),
            chartView.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor, constant: -20)
        ])

        chartView.chartDescription.enabled = false
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.granularity = 1
        chartView.xAxis.labelFont = UIFont.custom(10, .semiBold)
        chartView.xAxis.labelTextColor = AppColor.text.color
        chartView.doubleTapToZoomEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
    }

    private func render() {
        renderSegmentedControl()
        renderMetrics()
        renderChart()
        renderBadges()
    }

    private func renderSegmentedControl() {
        let selectedColor = UIColor(hex: 0x0F71BA)
        let normalColor = AppColor.text.color
        todayButton.backgroundColor = viewModel.selectedRange == .today ? .white : .clear
        weekButton.backgroundColor = viewModel.selectedRange == .week ? .white : .clear
        todayButton.setTitleColor(viewModel.selectedRange == .today ? selectedColor : normalColor, for: .normal)
        weekButton.setTitleColor(viewModel.selectedRange == .week ? selectedColor : normalColor, for: .normal)
        todayButton.layer.cornerRadius = 22
        weekButton.layer.cornerRadius = 22
    }

    private func renderMetrics() {
        let stats = viewModel.selectedStats
        timeValueLabel.text = String(format: "%d min".localize(), stats.minutes)
        starsValueLabel.text = "\(stats.stars)"
        completionPercentLabel.text = "\(stats.completionPercent)%"
        currentCompletionPercent = stats.completionPercent
        updateCompletionRing(percent: stats.completionPercent, animated: true)
    }

    private func renderChart() {
        let points = viewModel.weeklyActivity
        let entries = points.enumerated().map {
            BarChartDataEntry(x: Double($0.offset), y: Double($0.element.completedTasks))
        }

        let dataSet = BarChartDataSet(entries: entries, label: "Completed exercises".localize())
        dataSet.colors = [
            UIColor(hex: 0x35ADFF),
            UIColor(hex: 0x63C8FF),
            UIColor(hex: 0xFFC700),
            UIColor(hex: 0xFF902D),
            UIColor(hex: 0x35ADFF),
            UIColor(hex: 0x63C8FF),
            UIColor(hex: 0xFFC700)
        ]
        dataSet.drawValuesEnabled = false
        dataSet.highlightEnabled = false

        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.42
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: points.map(\.dayLabel))
        chartView.data = data
        chartView.animate(yAxisDuration: 0.7, easingOption: .easeOutBack)
    }

    private func renderBadges() {
        let badges = viewModel.badges
        for index in badgeViews.indices {
            guard badges.indices.contains(index) else {
                badgeViews[index].isHidden = true
                continue
            }

            let badge = badges[index]
            badgeViews[index].isHidden = false
            badgeIconViews[index].backgroundColor = UIColor(hex: badge.backgroundHex)
            badgeIconImageViews[index].image = UIImage(systemName: badge.symbolName)
            badgeIconImageViews[index].tintColor = .white
            badgeTitleLabels[index].text = badge.title
            badgeSubtitleLabels[index].text = badge.subtitle
        }
    }

    private func styleCard(_ view: UIView, cornerRadius: CGFloat = 30, shadowOpacity: Float = 0.07) {
        view.backgroundColor = .white
        view.layer.cornerRadius = cornerRadius
        view.addShadow(color: UIColor(hex: 0x00264D), opacity: shadowOpacity, offset: CGSize(width: 0, height: 8), radius: 16)
    }

    private func updateCompletionRing(percent: Int, animated: Bool) {
        guard completionRingView.bounds.width > 0 else { return }

        let center = CGPoint(x: completionRingView.bounds.midX, y: completionRingView.bounds.midY)
        let radius = min(completionRingView.bounds.width, completionRingView.bounds.height) / 2 - 6
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: .pi * 1.5,
            clockwise: true
        )

        [ringTrackLayer, ringProgressLayer].forEach {
            if $0.superlayer == nil {
                completionRingView.layer.addSublayer($0)
            }
            $0.path = path.cgPath
            $0.fillColor = UIColor.clear.cgColor
            $0.lineWidth = 8
            $0.lineCap = .round
        }

        ringTrackLayer.strokeColor = UIColor(hex: 0xDFE8FA).cgColor
        ringTrackLayer.strokeEnd = 1
        ringProgressLayer.strokeColor = UIColor(hex: 0xFF8800).cgColor

        let strokeEnd = CGFloat(percent) / 100
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = ringProgressLayer.presentation()?.strokeEnd ?? ringProgressLayer.strokeEnd
            animation.toValue = strokeEnd
            animation.duration = 0.45
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            ringProgressLayer.add(animation, forKey: "completionRing")
        }
        ringProgressLayer.strokeEnd = strokeEnd
    }

    @IBAction private func handleBack(_ sender: UIButton) {
        viewModel.navigateBack()
    }

    @IBAction private func handleTodayTap(_ sender: UIButton) {
        viewModel.selectRange(.today)
        render()
    }

    @IBAction private func handleWeekTap(_ sender: UIButton) {
        viewModel.selectRange(.week)
        render()
    }
}
