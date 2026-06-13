//
//  ListAlphabetController.swift
//  KidX
//
//  Created by 𝙢𝙩 on 14/6/26.
//

import UIKit

final class ListAlphabetController: BaseController {
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!

    private let viewModel: ListAlphabetViewModel

    init(viewModel: ListAlphabetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupUI() {
        view.backgroundColor = .clear
        setupLabels()
        setupCollectionView()
        setupBackButton()
    }

    private func setupLabels() {
        titleLabel.text = "Choose a Letter".localize()
        titleLabel.font = UIFont.custom(28, .cherryBombRegular)
        titleLabel.textColor = AppColor.text.color
        subtitleLabel.text = "Pick a letter to color inside the lines.".localize()
        subtitleLabel.font = UIFont.custom(14, .regular)
        subtitleLabel.textColor = AppColor.grey.color
    }

    private func setupCollectionView() {
        collectionView.registerNib(for: LetterCollectionCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 18, left: 0, bottom: 32, right: 0)
    }

    private func setupBackButton() {
        backButton.setImage(UIImage(resource: .icFlcBack), for: .normal)
        backButton.tintColor = AppColor.text.color
    }

    @IBAction private func backTapped(_ sender: UIButton) {
        viewModel.navigateBack()
    }
}

extension ListAlphabetController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.letters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LetterCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: viewModel.letters[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectLetter(viewModel.letters[indexPath.item])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 14
        let width = (collectionView.bounds.width - spacing * 3) / 4
        return CGSize(width: width, height: 72)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        14
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
}
