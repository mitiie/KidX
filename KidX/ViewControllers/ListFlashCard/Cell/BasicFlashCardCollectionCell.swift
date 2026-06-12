//
//  BasicFlashCardCollectionCell.swift
//  KidX
//
//  Created by mt on 13/6/26.
//

import UIKit
import AVFoundation

final class BasicFlashCardCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var wordLabel: UILabel!
    @IBOutlet private weak var audioButton: UIButton!

    private static let speechSynthesizer = AVSpeechSynthesizer()
    private var item: BasicFlashCardItem?
    private var isFlipped = false

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func configure(with item: BasicFlashCardItem, isFlipped: Bool) {
        self.item = item
        self.isFlipped = isFlipped
        updateContent()
    }

    func flip() {
        isFlipped.toggle()
        UIView.transition(with: contentView, duration: 0.28, options: [.transitionFlipFromRight, .allowUserInteraction]) {
            self.updateContent()
        }
    }

    private func setupUI() {
        contentView.layer.cornerRadius = 22
        contentView.layer.borderWidth = 2
        contentView.layer.shadowColor = UIColor(hex: 0x00264D).cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 8)
        contentView.layer.shadowRadius = 14

        audioButton.layer.cornerRadius = 18
        audioButton.clipsToBounds = true
        audioButton.accessibilityLabel = "Listen".localize()
    }

    private func updateContent() {
        guard let item else { return }

        languageLabel.text = isFlipped ? "English".localize() : "Vietnamese".localize()
        wordLabel.text = isFlipped ? item.englishText : item.vietnameseText
        contentView.backgroundColor = isFlipped ? UIColor(hex: 0xFFF4D9) : .white
        contentView.layer.borderColor = (isFlipped ? UIColor(hex: 0xFFC766) : UIColor(hex: 0xD7E6FF)).cgColor
    }

    @IBAction private func handleAudioTap(_ sender: UIButton) {
        guard let item else { return }

        let text = isFlipped ? item.englishText : item.vietnameseText
        let languageCode = isFlipped ? "en-US" : "vi-VN"
        speak(text: text, languageCode: languageCode)
    }

    private func speak(text: String, languageCode: String) {
        if Self.speechSynthesizer.isSpeaking {
            Self.speechSynthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        utterance.rate = 0.45
        Self.speechSynthesizer.speak(utterance)
    }
}
