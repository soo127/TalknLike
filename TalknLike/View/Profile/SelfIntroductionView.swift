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
    }

    // Placeholder
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

}

extension SelfIntroductionView {
    
    private func setupTextView() {
        textView.delegate = self
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.isScrollEnabled = false
        
        addSubview(textView)
        textView.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16),
            height: 150
        )
    }
    
    private func setupPlaceholder() {
        placeholderLabel.text = "자기소개를 입력하세요"
        placeholderLabel.textColor = .placeholderText
        placeholderLabel.font = .systemFont(ofSize: 16)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(
            top: textView.topAnchor,
            leading: textView.leadingAnchor,
            padding: UIEdgeInsets(top: 8, left: 5, bottom: 0, right: 0),
        )
    }
    
    private func setupSeparator() {
        separator.backgroundColor = .systemGray
        
        addSubview(separator)
        separator.anchor(
            top: textView.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16),
            height: 1
        )
    }
    
}
