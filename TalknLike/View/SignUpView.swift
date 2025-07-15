//
//  SignUpView.swift
//  TalknLike
//
//  Created by 이상수 on 7/14/25.
//

import UIKit

final class SignUpView: UIView {
    
    let idField = UITextField.make("아이디")
    let passwordField = UITextField.make("비밀번호 (8자 이상)", secure: true)
    let passwordCheckField = UITextField.make("비밀번호 확인", secure: true)
    let phoneField = UITextField.make("전화번호", numberOnly: true)
    let verifyButton = UIButton.make("인증", backgroundColor: .systemGray2)
    let signUpButton = UIButton.make("회원가입", backgroundColor: .systemBlue, height: 44)
    private lazy var phoneStack = UIStackView.horizontalStack(views: [phoneField, verifyButton])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .white
        signUpButton.isEnabled = false
        signUpButton.alpha = 0.5
    }

    private func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [
            makeField(icon: "person.fill", text: "아이디", field: idField),
            makeField(icon: "lock.fill", text: "비밀번호", field: passwordField),
            makeField(icon: "lock.fill", text: "비밀번호 확인", field: passwordCheckField),
            makeField(icon: "phone.fill", text: "전화번호", field: phoneStack),
            signUpButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])

        phoneField.translatesAutoresizingMaskIntoConstraints = false
        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        phoneField.widthAnchor.constraint(equalTo: phoneStack.widthAnchor, multiplier: 0.7).isActive = true
    }

    private func makeField(icon: String, text: String, field: UIView) -> UIStackView {
        let icon = UIImageView(image: UIImage(systemName: icon))
        icon.tintColor = .gray
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 20).isActive = true

        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray

        let titleStack = UIStackView(arrangedSubviews: [icon, label])
        titleStack.axis = .horizontal
        titleStack.spacing = 6

        let mainStack = UIStackView(arrangedSubviews: [titleStack, field])
        mainStack.axis = .vertical
        mainStack.spacing = 6
        return mainStack
    }
    
}


