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
        textView.delegate = self
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        placeholderLabel.text = "자기소개를 입력하세요"
        placeholderLabel.textColor = .placeholderText
        placeholderLabel.font = .systemFont(ofSize: 16)
        
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.isScrollEnabled = false
        
        separator.backgroundColor = .systemGray5

        addSubview(textView)
        addSubview(placeholderLabel)
        addSubview(separator)

        textView.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(equalToConstant: 150),

            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5),

            separator.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    // Placeholder
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

}
