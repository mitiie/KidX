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

    private var itemImageView: UIImageView?
    private var centerYConstraint: NSLayoutConstraint?
    private var customConstraints: [NSLayoutConstraint] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func configure(with item: BasicFlashCardItem, isFlipped: Bool) {
        self.item = item
        self.isFlipped = isFlipped

        NSLayoutConstraint.deactivate(customConstraints)
        customConstraints.removeAll()

        if let filename = item.imageFilename {
            itemImageView?.isHidden = false
            centerYConstraint?.isActive = false

            loadImageAsync(filename: filename) { [weak self] image in
                self?.itemImageView?.image = image
            }

            if let itemImageView = itemImageView {
                let constraints = [
                    itemImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                    itemImageView.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 12),
                    itemImageView.bottomAnchor.constraint(equalTo: wordLabel.topAnchor, constant: -12),
                    itemImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
                    wordLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
                ]
                customConstraints = constraints
                NSLayoutConstraint.activate(constraints)
            }
        } else {
            itemImageView?.isHidden = true
            itemImageView?.image = nil
            centerYConstraint?.isActive = true
        }

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

        // Khởi tạo ImageView động hiển thị hình ảnh đã chụp
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        self.itemImageView = imageView

        // Tìm constraint centerY của wordLabel để tắt đi khi có hình ảnh
        for constraint in self.constraints {
            if (constraint.firstItem as? UIView) == wordLabel && constraint.firstAttribute == .centerY {
                self.centerYConstraint = constraint
                break
            }
            if (constraint.secondItem as? UIView) == wordLabel && constraint.secondAttribute == .centerY {
                self.centerYConstraint = constraint
                break
            }
        }
    }

    private func updateContent() {
        guard let item else { return }

        let showEnglish: Bool
        if LocalizeHelper.shared.isVietnameseSelected {
            showEnglish = isFlipped
        } else {
            showEnglish = !isFlipped
        }

        languageLabel.text = showEnglish ? "English".localize() : "Vietnamese".localize()
        wordLabel.text = showEnglish ? item.englishText : item.vietnameseText
        contentView.backgroundColor = showEnglish ? UIColor(hex: 0xFFF4D9) : .white
        contentView.layer.borderColor = (showEnglish ? UIColor(hex: 0xFFC766) : UIColor(hex: 0xD7E6FF)).cgColor
    }

    @IBAction private func handleAudioTap(_ sender: UIButton) {
        guard let item else { return }

        let showEnglish: Bool
        if LocalizeHelper.shared.isVietnameseSelected {
            showEnglish = isFlipped
        } else {
            showEnglish = !isFlipped
        }

        let text = showEnglish ? item.englishText : item.vietnameseText
        let languageCode = showEnglish ? "en-US" : "vi-VN"
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

    private func loadImageAsync(filename: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = docsDir.appendingPathComponent(filename)
            
            let image: UIImage?
            if let data = try? Data(contentsOf: fileURL) {
                image = UIImage(data: data)
            } else {
                image = UIImage(named: filename)
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
