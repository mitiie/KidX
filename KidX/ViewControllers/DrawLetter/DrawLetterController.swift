//
//  DrawLetterController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 14/6/26.
//

import UIKit

final class DrawLetterController: BaseController {
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var caseSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var coloringView: LetterColoringView!
    @IBOutlet private weak var toolbarView: UIView!
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private var colorButtons: [UIButton]!
    @IBOutlet private var widthButtons: [UIButton]!

    private let viewModel: DrawLetterViewModel
    private let colors: [UIColor] = [
        UIColor(hex: 0xF8A23A),
        UIColor(hex: 0xEF6BA2),
        UIColor(hex: 0x35ADFF),
        UIColor(hex: 0x7BD66D),
        UIColor(hex: 0x8E61BD)
    ]
    private let widths: [CGFloat] = [36, 52, 68]

    init(viewModel: DrawLetterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupUI() {
        setupHeader()
        setupColoringView()
        setupToolbar()
    }

    private func setupHeader() {
        backButton.setImage(UIImage(resource: .icFlcBack), for: .normal)
        backButton.tintColor = AppColor.text.color
        titleLabel.text = "Color the Letter".localize()
        titleLabel.font = UIFont.custom(24, .cherryBombRegular)
        titleLabel.textColor = AppColor.text.color

        caseSegmentedControl.setTitle(viewModel.letter.uppercase, forSegmentAt: 0)
        caseSegmentedControl.setTitle(viewModel.letter.lowercase, forSegmentAt: 1)
        caseSegmentedControl.selectedSegmentIndex = 0
        caseSegmentedControl.selectedSegmentTintColor = UIColor(hex: 0xFFCC66)
        caseSegmentedControl.setTitleTextAttributes([
            .font: UIFont.custom(16, .semiBold),
            .foregroundColor: AppColor.text.color
        ], for: .normal)
    }

    private func setupColoringView() {
        coloringView.letter = viewModel.letter
        coloringView.isUppercase = true
        coloringView.drawingColor = colors[0]
        coloringView.drawingWidth = widths[1]
    }

    private func setupToolbar() {
        toolbarView.backgroundColor = .white
        toolbarView.layer.cornerRadius = 28
        toolbarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        toolbarView.addShadow(color: UIColor(hex: 0x00264D), opacity: 0.08, offset: CGSize(width: 0, height: -6), radius: 18)

        clearButton.setTitle("Clear".localize(), for: .normal)
        clearButton.titleLabel?.font = UIFont.custom(13, .semiBold)
        clearButton.setTitleColor(AppColor.text.color, for: .normal)
        clearButton.backgroundColor = UIColor(hex: 0xFFF3E0)
        clearButton.layer.cornerRadius = 18

        colorButtons.sort { $0.tag < $1.tag }
        for button in colorButtons {
            let color = colors[button.tag]
            button.backgroundColor = color
            button.layer.cornerRadius = 17
            button.layer.borderWidth = button.tag == 0 ? 3 : 0
            button.layer.borderColor = UIColor(hex: 0xFFCC66).cgColor
        }

        widthButtons.sort { $0.tag < $1.tag }
        for button in widthButtons {
            button.layer.cornerRadius = 18
            button.backgroundColor = button.tag == 1 ? UIColor(hex: 0xE6F0FF) : UIColor(hex: 0xF4F6FA)
            button.tintColor = button.tag == 1 ? AppColor.primary.color : AppColor.grey.color
        }
    }

    private func updateSelectedColor(index: Int) {
        coloringView.drawingColor = colors[index]
        for button in colorButtons {
            button.layer.borderWidth = button.tag == index ? 3 : 0
        }
    }

    private func updateSelectedWidth(index: Int) {
        coloringView.drawingWidth = widths[index]
        for button in widthButtons {
            button.backgroundColor = button.tag == index ? UIColor(hex: 0xE6F0FF) : UIColor(hex: 0xF4F6FA)
            button.tintColor = button.tag == index ? AppColor.primary.color : AppColor.grey.color
        }
    }

    @IBAction private func backTapped(_ sender: UIButton) {
        viewModel.navigateBack()
    }

    @IBAction private func caseChanged(_ sender: UISegmentedControl) {
        coloringView.isUppercase = sender.selectedSegmentIndex == 0
    }

    @IBAction private func colorTapped(_ sender: UIButton) {
        guard colors.indices.contains(sender.tag) else { return }
        updateSelectedColor(index: sender.tag)
    }

    @IBAction private func widthTapped(_ sender: UIButton) {
        guard widths.indices.contains(sender.tag) else { return }
        updateSelectedWidth(index: sender.tag)
    }

    @IBAction private func clearTapped(_ sender: UIButton) {
        coloringView.clear()
    }
}
