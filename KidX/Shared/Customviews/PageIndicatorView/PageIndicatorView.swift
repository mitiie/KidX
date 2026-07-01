//
//  PageIndicatorView.swift
//  DIYWallpaper
//
//  Created by mitie on 25/3/26.
//

import UIKit

class PageIndicatorView: UIView, XibLoadable {
    @IBOutlet weak var stackView: UIStackView!

    var activeColor: UIColor = AppColor.primary.color
    var inactiveColor: UIColor = AppColor.white.color
    var activeWidth: CGFloat = 24
    var inactiveWidth: CGFloat = 6
    var dotHeight: CGFloat = 6

    private var dots: [UIView] = []
    private var widthConstraints: [NSLayoutConstraint] = []
    
    var numberOfPages: Int = 0 {
        didSet {
            if oldValue != numberOfPages {
                buildDots()
            }
        }
    }

    var currentPage: Int = 0 {
        didSet {
            updateDots(animated: true)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fill
    }
    
    override var intrinsicContentSize: CGSize {
        let spacing = stackView.spacing
        let dotsWidth = CGFloat(max(0, numberOfPages - 1)) * inactiveWidth + (numberOfPages > 0 ? activeWidth : 0)
        let totalSpacing = CGFloat(max(0, numberOfPages - 1)) * spacing
        return CGSize(width: dotsWidth + totalSpacing, height: dotHeight)
    }

    private func buildDots() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        dots.removeAll()
        widthConstraints.removeAll()

        for i in 0..<numberOfPages {
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
        invalidateIntrinsicContentSize()
    }

    // MARK: - Public
    func setPage(_ page: Int, totalPages: Int = 3, animated: Bool = true) {
        if self.numberOfPages != totalPages {
            self.numberOfPages = totalPages
        }
        self.currentPage = page
    }

    private func updateDots(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.25 : 0, delay: 0, options: .curveEaseOut, animations: {
            for (i, dot) in self.dots.enumerated() {
                let isActive = i == self.currentPage
                dot.backgroundColor = isActive ? self.activeColor : self.inactiveColor
                self.widthConstraints[i].constant = isActive ? self.activeWidth : self.inactiveWidth
            }
            self.stackView.layoutIfNeeded()
        }, completion: nil)
    }
}
