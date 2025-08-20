//
//  NicknameEditView.swift
//  TalknLike
//
//  Created by 이상수 on 7/28/25.
//

import UIKit

final class NicknameEditView: UIView {
    
    let textField = UITextField()
    private let separator = UIView()
    private let characterCountLabel = UILabel()
    let maxCharacterCount = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupTextField()
        setupSeparator()
        setupCharacterCountLabel()
        setupLayout()
    }
    
}

extension NicknameEditView {
    
    private func setupTextField() {
        textField.placeholder = "닉네임 입력"
        textField.backgroundColor = .systemBackground
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupSeparator() {
        separator.backgroundColor = .systemGray5
    }
    
    private func setupCharacterCountLabel() {
        characterCountLabel.font = .systemFont(ofSize: 12)
        characterCountLabel.textColor = .systemGray
        characterCountLabel.textAlignment = .right
        characterCountLabel.text = "0/\(maxCharacterCount)"
    }
    
    @objc private func textFieldDidChange() {
        let currentCount = textField.text?.count ?? 0
        characterCountLabel.text = "\(currentCount)/\(maxCharacterCount)"
        characterCountLabel.textColor = currentCount > maxCharacterCount ? .systemRed : .systemGray
    }
    
    private func setupLayout() {
        addSubview(textField)
        addSubview(separator)
        addSubview(characterCountLabel)

        textField.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        )
        separator.anchor(
            top: textField.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16),
            height: 1
        )
        characterCountLabel.anchor(
            top: separator.bottomAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        )
    }
    
}

extension NicknameEditView {
    
    func isAvailableNickname(_ nickname: String?) -> Bool {
        guard let nickname, nickname.count > 0 else {
            return false
        }
        return nickname.count <= maxCharacterCount
    }

}
