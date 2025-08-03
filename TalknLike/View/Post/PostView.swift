//
//  PostView.swift
//  TalknLike
//
//  Created by 이상수 on 7/29/25.
//

import UIKit

final class PostView: UIView, UITextViewDelegate {
    
    private let placeholderLabel = UILabel()
    let profileImageView = UIImageView()
    let editButton = UIButton(type: .system)
    let nicknameLabel = UILabel()
    let textView = UITextView()
    private let separator = UIView()
    private var profileHeader = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupHeader()
        setupPost()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
}

extension PostView {
    
    private func setupHeader() {
        setupTextView()
        setupPlaceholder()
        setupProfileImageView()
        setupEditButton()
        setupNicknameLabel()
        
        let vStack = UIStackView.make(views: [nicknameLabel, editButton], axis: .vertical, spacing: 4)
        vStack.alignment = .leading
        profileHeader = UIStackView.make(views: [profileImageView, vStack], axis: .horizontal, spacing: 12)
    }
    
    private func setupPost() {
        let postView = UIStackView(arrangedSubviews: [profileHeader, separator, textView])
        postView.axis = .vertical
        postView.spacing = 12
        
        addSubview(postView)
        postView.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
        )
    }
    
    private func setupTextView() {
        textView.delegate = self
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        
        textView.addSubview(placeholderLabel)
        textView.anchor(height: 300)
    }
    
    private func setupPlaceholder() {
        placeholderLabel.text = "이 텍스트창이 당신을 기다리고 있어요."
        placeholderLabel.textColor = .placeholderText
        placeholderLabel.font = .systemFont(ofSize: 16)
        
        placeholderLabel.anchor(
            top: textView.topAnchor,
            leading: textView.leadingAnchor,
            padding: UIEdgeInsets(top: 8, left: 5, bottom: 0, right: 0)
        )
    }
    
    private func setupProfileImageView() {
        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true
        
        profileImageView.anchor(width: 60, height: 60)
    }
    
    private func setupEditButton() {
        editButton.setTitle("편집", for: .normal)
    }
    
    private func setupNicknameLabel() {
        nicknameLabel.font = .boldSystemFont(ofSize: 20)
        nicknameLabel.text = "닉네임"
    }
    
    private func setupSeparator() {
        separator.backgroundColor = .systemGray5
        separator.anchor(height: 1)
    }

}
