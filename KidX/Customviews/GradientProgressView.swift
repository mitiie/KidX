//
//  GradientProgressView.swift
//  DIYWallpaper
//
//  Created by mitie on 4/3/26.
//

import UIKit

class GradientProgressView: UIView {
    // MARK: - Sublayers & Subviews
    private let trackLayer      = CALayer()
    private let gradientLayer = CAGradientLayer.horizontal(colors: UIColor.progressGradientColors)
    private let progressMask    = CALayer()

    // MARK: - Animation state
    private var displayLink: CADisplayLink?
    private var animStartTime: CFTimeInterval = 0
    private var animDuration:  CFTimeInterval = 0
    private var fromProgress:  CGFloat = 0
    private var toProgress:    CGFloat = 0
    private let borderLayer = CALayer()
    
    // MARK: - Public progress
    private var _progress: CGFloat = 0
    var progress: CGFloat {
        get { _progress }
        set { _progress = max(0, min(1, newValue)) }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        backgroundColor = .clear
        clipsToBounds = false

        trackLayer.backgroundColor = UIColor.white.cgColor
        [trackLayer, gradientLayer, borderLayer].forEach {
            layer.addSublayer($0)
        }
        progressMask.backgroundColor = UIColor.black.cgColor
        gradientLayer.mask = progressMask
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.borderColor = UIColor.white.cgColor
        borderLayer.borderWidth = 2
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        let r = bounds.height / 2
        trackLayer.frame        = bounds
        trackLayer.cornerRadius = r
        gradientLayer.frame     = bounds
        gradientLayer.cornerRadius = r
        borderLayer.frame = bounds
        borderLayer.cornerRadius = bounds.height / 2
        applyProgress(_progress)
    }

    // MARK: - Public API
    func setProgress(_ newProgress: CGFloat, duration: TimeInterval = 0.5) {
        stopDisplayLink()

        fromProgress  = _progress
        toProgress    = max(0, min(1, newProgress))
        animDuration  = max(duration, 0.001)
        animStartTime = CACurrentMediaTime()

        displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink?.add(to: .main, forMode: .common)
    }

    // MARK: - CADisplayLink callback
    @objc private func tick() {
        let elapsed = CACurrentMediaTime() - animStartTime
        let rawT    = elapsed / animDuration
        let t       = min(rawT, 1.0)

        let eased   = easeInOutCubic(t)
        let current = fromProgress + (toProgress - fromProgress) * CGFloat(eased)

        _progress = current
        applyProgress(current)

        if t >= 1.0 {
            stopDisplayLink()
        }
    }

    // MARK: - Core update
    private func applyProgress(_ p: CGFloat) {
        guard bounds.width > 0 else { return }

        let progressWidth = bounds.width * p

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressMask.frame = CGRect(x: 0, y: 0, width: progressWidth, height: bounds.height)
        CATransaction.commit()
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    private func easeInOutCubic(_ t: Double) -> Double {
        return t < 0.5
            ? 4 * t * t * t
            : 1 - pow(-2 * t + 2, 3) / 2
    }
}
