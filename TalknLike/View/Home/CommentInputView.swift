//
//  CommentInputView.swift
//  TalknLike
//
//  Created by 이상수 on 8/18/25.
//

import UIKit

protocol CommentInputViewDelegate: AnyObject {
    func commentInputView(didSubmit text: String?)
}

final class CommentInputView: UIView {
    
    weak var delegate: CommentInputViewDelegate?
    let profileImageView = UIImageView()
    let textField = UITextField()
    private let defaultPlaceHolder = "댓글 추가..."
    
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

extension CommentInputView {
    
    private func setupSubviews() {
        setupProfileImageView()
        setupTextField()
    }
    
    private func setupProfileImageView() {
        addSubview(profileImageView)
        profileImageView.image = UIImage(systemName: "person.circle")
        profileImageView.layer.cornerRadius = 18
        profileImageView.clipsToBounds = true
    }
    
    private func setupTextField() {
        addSubview(textField)
        textField.placeholder = defaultPlaceHolder
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.delegate = self
    }
    
}

extension CommentInputView {
    
    private func setupLayout() {
        layoutProfileImageView()
        layoutTextField()
    }
    
    private func layoutProfileImageView() {
        profileImageView.anchor(
            leading: leadingAnchor,
            padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0),
            width: 36,
            height: 36,
            centerY: centerYAnchor,
        )
    }
    
    private func layoutTextField() {
        textField.anchor(
            leading: profileImageView.trailingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8),
            centerY: centerYAnchor,
        )
    }
    
}

extension CommentInputView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.commentInputView(didSubmit: textField.text)
        return true
    }
    
    func clearText() {
        textField.text = ""
    }
    
}

extension CommentInputView {

    var isClicked: Bool {
        textField.isFirstResponder
    }
    
    func setupReply(nickname: String, commentID: String?) {
        textField.placeholder = "@\(nickname) 님에게 회신"
        textField.becomeFirstResponder()
    }
    
    func clearReply() {
        textField.placeholder = defaultPlaceHolder
    }
    
    func configure(profileImageURL: String?) {
        Task { @MainActor [weak self] in
            self?.profileImageView.image = await ImageLoader.loadImage(from: profileImageURL)
        }
    }
    
}
