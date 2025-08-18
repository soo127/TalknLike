//
//  CommentInputView.swift
//  TalknLike
//
//  Created by 이상수 on 8/18/25.
//

import UIKit

protocol CommentInputViewDelegate: AnyObject {
    func commentInputView(_ inputView: CommentInputView, didSubmit text: String?)
}

final class CommentInputView: UIView {
    
    weak var delegate: CommentInputViewDelegate?
    let profileImageView = UIImageView()
    let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupProfileImageView()
        setupTextField()
        setupLayout()
    }
    
}

extension CommentInputView {
    
    private func setupProfileImageView() {
        profileImageView.layer.cornerRadius = 18
        profileImageView.clipsToBounds = true
    }
    
    private func setupTextField() {
        textField.placeholder = "댓글 추가..."
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        textField.delegate = self
    }
    
    private func setupLayout() {
        addSubview(profileImageView)
        addSubview(textField)
        
        profileImageView.anchor(
            leading: leadingAnchor,
            padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0),
            width: 36,
            height: 36,
            centerY: centerYAnchor,
        )
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
        delegate?.commentInputView(self, didSubmit: textField.text)
        return true
    }
    
    func clearText() {
        textField.text = ""
    }
    
}
