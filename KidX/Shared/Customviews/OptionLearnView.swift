//
//  OptionLearnView.swift
//  MV_2570
//
//  Created by Bui Minh Tien on 30/6/25.
//

import UIKit

class OptionLearnView: UIView {
    private let backgroundIMG = UIImageView(image: UIImage(resource: .bgOptionLearn))
    private let learnStarLabel = OptionLearnView.makeLabel(text: "Unremembered")
    private let randomLabel = OptionLearnView.makeLabel(text: "Random")
    private let nextIcon1 = OptionLearnView.makeNextIcon()
    private let nextIcon2 = OptionLearnView.makeNextIcon()
    let view1 = UIView()
    let view2 = UIView()

    var onLearnStarTapped: (() -> Void)?
    var onRandomTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        layoutViews()
        setupGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupGestureRecognizers() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(handleView1Tapped))
        view1.addGestureRecognizer(tap1)
        view1.isUserInteractionEnabled = true

        let tap2 = UITapGestureRecognizer(target: self, action: #selector(handleView2Tapped))
        view2.addGestureRecognizer(tap2)
        view2.isUserInteractionEnabled = true
    }

    @objc private func handleView1Tapped() {
        onLearnStarTapped?()
    }

    @objc private func handleView2Tapped() {
        onRandomTapped?()
    }

    private func setupUI() {
        backgroundIMG.contentMode = .scaleAspectFit
        backgroundIMG.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundIMG)

        [view1, view2].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        add(view1, label: learnStarLabel, icon: nextIcon1)
        add(view2, label: randomLabel, icon: nextIcon2)
    }

    private func layoutViews() {
        NSLayoutConstraint.activate([
            backgroundIMG.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundIMG.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundIMG.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            backgroundIMG.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/3),

            view2.bottomAnchor.constraint(equalTo: backgroundIMG.bottomAnchor, constant: -(0.3 * backgroundIMG.bounds.height)),
            view2.widthAnchor.constraint(equalTo: backgroundIMG.widthAnchor, multiplier: 0.75),
            view2.heightAnchor.constraint(equalToConstant: 40),
            view2.centerXAnchor.constraint(equalTo: centerXAnchor),

            view1.bottomAnchor.constraint(equalTo: view2.topAnchor, constant: -10),
            view1.widthAnchor.constraint(equalTo: view2.widthAnchor),
            view1.heightAnchor.constraint(equalTo: view2.heightAnchor),
            view1.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    // MARK: - Helper
    private func add(_ container: UIView, label: UILabel, icon: UIImageView) {
        [label, icon].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview($0)
        }

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            icon.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            icon.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }

    private static func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.custom(16, .semiBold)
        label.textColor = .white
        return label
    }

    private static func makeNextIcon() -> UIImageView {
        let iv = UIImageView(image: UIImage(resource: .next))
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }
}
