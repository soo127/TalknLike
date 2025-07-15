//
//  NewPwView.swift
//  TalknLike
//
//  Created by 이상수 on 7/15/25.
//

import UIKit

final class NewPwView: UIView, StepView {

    var onNext: (() -> Void)?

    let passwordField = UITextField()
    let confirmField = UITextField()
    let finishButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .white

        passwordField.placeholder = "새 비밀번호"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true

        confirmField.placeholder = "비밀번호 확인"
        confirmField.borderStyle = .roundedRect
        confirmField.isSecureTextEntry = true

        finishButton.setTitle("완료", for: .normal)
        finishButton.backgroundColor = .systemBlue
        finishButton.tintColor = .white
        finishButton.layer.cornerRadius = 6
        finishButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [passwordField, confirmField, finishButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            finishButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

extension NewPwView {
    
    @objc private func tapped() {
        onNext?()
    }
}
