//
//  SelfIntroductionView.swift
//  TalknLike
//
//  Created by 이상수 on 7/25/25.
//

import UIKit

protocol SelfIntroductionViewDelegate: AnyObject {
    func textDidChange(_ text: String)
    func shouldChangeText(currentText: String, range: NSRange, text: String) -> Bool
}

final class SelfIntroductionView: UIView {

    private let placeholderLabel = UILabel()
    let textView = UITextView()
    private let separator = UIView()
    private let characterCountLabel = UILabel()
    let maxCount = 40
    
    weak var delegate: SelfIntroductionViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupSubviews()
        setupLayout()
    }
    
}


extension SelfIntroductionView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textDidChange(textView.text)
    }

    func update(text: String) {
        textView.text = text
        characterCountLabel.text = "\(text.count)/\(maxCount)"
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return delegate?.shouldChangeText(
            currentText: textView.text ?? "",
            range: range,
            text: text) ?? true
    }
    
}

extension SelfIntroductionView {
    
    private func setupSubviews() {
        setupTextView()
        setupPlaceholder()
        setupSeparator()
        setupCountLabel()
    }
    
    private func setupTextView() {
        addSubview(textView)
        textView.delegate = self
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.isScrollEnabled = false
    }
    
    private func setupPlaceholder() {
        addSubview(placeholderLabel)
        placeholderLabel.text = "자기소개를 입력하세요"
        placeholderLabel.textColor = .placeholderText
        placeholderLabel.font = .systemFont(ofSize: 16)
    }
 
    private func setupSeparator() {
        addSubview(separator)
        separator.backgroundColor = .systemGray
    }
    
    private func setupCountLabel() {
        addSubview(characterCountLabel)
        characterCountLabel.text = "0/\(maxCount)"
        characterCountLabel.font = .systemFont(ofSize: 12)
        characterCountLabel.textColor = .systemGray
        characterCountLabel.textAlignment = .right
    }

}


extension SelfIntroductionView {
    
    private func setupLayout() {
        layoutTextView()
        layoutPlaceholder()
        layoutSeparator()
        layoutCountLabel()
    }
    
    private func layoutTextView() {
        textView.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16),
            height: 60
        )
    }
    
    private func layoutPlaceholder() {
        placeholderLabel.anchor(
            top: textView.topAnchor,
            leading: textView.leadingAnchor,
            padding: UIEdgeInsets(top: 8, left: 5, bottom: 0, right: 0)
        )
    }
    
    private func layoutSeparator() {
        separator.anchor(
            top: textView.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16),
            height: 1
        )
    }
    
    private func layoutCountLabel() {
        characterCountLabel.anchor(
            top: separator.bottomAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 16)
        )
    }
    
}
