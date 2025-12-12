//
//  PostView.swift
//  TalknLike
//
//  Created by 이상수 on 7/29/25.
//

import UIKit

final class PostView: UIView, UITextViewDelegate {
    
    private let placeholderLabel = UILabel()
    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let titleTextField = UITextField()
    private let textView = UITextView()
    private let separator = UIView()
    private var profileHeader = UIStackView()
    
    var title: String? { return titleTextField.text }
    var content: String? { return textView.text }
    
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
        setupNicknameLabel()
        setupTitleTextField()
        setupSeparator()
        profileHeader = UIStackView.make(
            views: [profileImageView, nicknameLabel],
            axis: .horizontal,
            spacing: 12,
            alignment: .top
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
    
    private func setupSeparator() {
        separator.backgroundColor = .systemGray5
        separator.anchor(height: 1)
    }

    private func setupNicknameLabel() {
        nicknameLabel.font = .boldSystemFont(ofSize: 20)
        nicknameLabel.text = "닉네임"
    }
    
    private func setupTitleTextField() {
        titleTextField.placeholder = "제목"
        titleTextField.font = .boldSystemFont(ofSize: 16)
        titleTextField.anchor(height: 30)
    }
    
    private func setupPost() {
        let postView = UIStackView(arrangedSubviews: [profileHeader, titleTextField, separator, textView])
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
    
}

extension PostView {
    
    func configure(user: UserProfile) {
        nicknameLabel.text = user.nickname
        Task { @MainActor [weak self] in
            self?.profileImageView.image = await ImageLoader.loadImage(from: user.photoURL) ?? UIImage(systemName: "person.fill")
        }
    }
    
    func configureEdit(post: Post) {
        textView.text = post.content
        titleTextField.text = post.title
        placeholderLabel.isHidden = true
    }

}
