//
//  SelfIntroductionView.swift
//  TalknLike
//
//  Created by 이상수 on 7/25/25.
//

import UIKit

final class SelfIntroductionView: UIView, UITextViewDelegate {

    private let placeholderLabel = UILabel()
    let textView = UITextView()
    private let separator = UIView()
    private let characterCountLabel = UILabel()
    
    private let maxCharacterCount = 40

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupTextView()
        setupPlaceholder()
        setupSeparator()
        setupCharacterCountLabel()
        setupLayout()
        updateCharacterCount()
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        updateCharacterCount()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        if text == "\n" {
            let newlineCount = currentText.components(separatedBy: "\n").count - 1
            if newlineCount >= 1 {
                return false
            }
        }
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let newText = currentText.replacingCharacters(in: stringRange, with: text)
        return newText.count <= maxCharacterCount
    }
    
    private func updateCharacterCount() {
        let currentCount = textView.text.count
        characterCountLabel.text = "\(currentCount)/\(maxCharacterCount)"
        if currentCount > maxCharacterCount {
            characterCountLabel.textColor = .systemRed
        } else {
            characterCountLabel.textColor = .systemGray
        }
    }
    
}

extension SelfIntroductionView {
    
    private func setupTextView() {
        textView.delegate = self
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.isScrollEnabled = false
    }
    
    private func setupPlaceholder() {
        placeholderLabel.text = "자기소개를 입력하세요"
        placeholderLabel.textColor = .placeholderText
        placeholderLabel.font = .systemFont(ofSize: 16)
    }
    
    private func setupSeparator() {
        separator.backgroundColor = .systemGray
    }
    
    private func setupCharacterCountLabel() {
        characterCountLabel.font = .systemFont(ofSize: 12)
        characterCountLabel.textColor = .systemGray
        characterCountLabel.textAlignment = .right
    }
    
    private func setupLayout() {
        addSubview(textView)
        addSubview(placeholderLabel)
        addSubview(separator)
        addSubview(characterCountLabel)

        textView.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16),
            height: 60
        )
        placeholderLabel.anchor(
            top: textView.topAnchor,
            leading: textView.leadingAnchor,
            padding: UIEdgeInsets(top: 8, left: 5, bottom: 0, right: 0)
        )
        separator.anchor(
            top: textView.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16),
            height: 1
        )
        characterCountLabel.anchor(
            top: separator.bottomAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 16)
        )
    }
    
}
