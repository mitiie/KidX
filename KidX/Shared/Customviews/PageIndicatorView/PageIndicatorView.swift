//
//  PageIndicatorView.swift
//  DIYWallpaper
//
//  Created by mitie on 25/3/26.
//

import UIKit

class PageIndicatorView: UIView {
    @IBOutlet weak var stackView: UIStackView!

    var activeColor: UIColor = AppColor.primary.color
    var inactiveColor: UIColor = UIColor.white
    var activeWidth: CGFloat = 32
    var inactiveWidth: CGFloat = 8
    var dotHeight: CGFloat = 8

    private var dots: [UIView] = []
    private var widthConstraints: [NSLayoutConstraint] = []
    private var currentPage: Int = 0
    private var totalPages: Int = 2

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PageIndicatorView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.distribution = .fill
        buildDots()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func buildDots() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        dots.removeAll()
        widthConstraints.removeAll()

        for i in 0..<totalPages {
            let dot = UIView()
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.layer.cornerRadius = dotHeight / 2
            dot.clipsToBounds = true
            dot.backgroundColor = i == currentPage ? activeColor : inactiveColor

            let widthConstraint = dot.widthAnchor.constraint(equalToConstant: i == currentPage ? activeWidth : inactiveWidth)
            let heightConstraint = dot.heightAnchor.constraint(equalToConstant: dotHeight)
            NSLayoutConstraint.activate([widthConstraint, heightConstraint])

            widthConstraints.append(widthConstraint)
            stackView.addArrangedSubview(dot)
            dots.append(dot)
        }
    }

    // MARK: - Public
    func setPage(_ page: Int, totalPages: Int = 2, animated: Bool = true) {
        if self.totalPages != totalPages {
            self.totalPages = totalPages
            buildDots()
        }
        currentPage = page
        updateDots(animated: animated)
    }

    private func updateDots(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.2 : 0) {
            for (i, dot) in self.dots.enumerated() {
                let isActive = i == self.currentPage
                dot.backgroundColor = isActive ? self.activeColor : self.inactiveColor
                self.widthConstraints[i].constant = isActive ? self.activeWidth : self.inactiveWidth
            }
            self.stackView.layoutIfNeeded()
        }
    }
}
