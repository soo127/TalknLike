//
//  SignUpView.swift
//  TalknLike
//
//  Created by 이상수 on 7/14/25.
//

import UIKit

final class SignUpView: UIView {
    
    let idField = UITextField()
    let passwordField = UITextField()
    let passwordCheckField = UITextField()
    let phoneField = UITextField()
    let verifyButton = UIButton(type: .system)
    let signUpButton = UIButton(type: .system)

    private lazy var phoneStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [phoneField, verifyButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillProportionally
        return stack
    }()
    
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
        
        [idField, passwordField, passwordCheckField, phoneField].forEach {
            $0.borderStyle = .roundedRect
            $0.autocapitalizationType = .none
        }

        idField.placeholder = "아이디"
        
        passwordField.placeholder = "비밀번호 (8자 이상)"
        passwordField.isSecureTextEntry = true
        
        passwordCheckField.placeholder = "비밀번호 확인"
        passwordCheckField.isSecureTextEntry = true

        phoneField.placeholder = "전화번호 (숫자만 입력)"
        phoneField.keyboardType = .numberPad

        verifyButton.setTitle("인증 요청", for: .normal)
        verifyButton.setTitleColor(.systemBlue, for: .normal)

        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.backgroundColor = .systemBlue
        signUpButton.tintColor = .white
        signUpButton.layer.cornerRadius = 8
        signUpButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
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


