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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupTextField()
        setupSeparator()
    }
    
}

extension NicknameEditView {
    
    private func setupTextField() {
        textField.placeholder = "닉네임 입력"
        textField.backgroundColor = .systemBackground
    }
    
    private func setupSeparator() {
        separator.backgroundColor = .systemGray5
    }
    
    private func setupLayout() {
        addSubview(textField)
        addSubview(separator)

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
    }
    
}
