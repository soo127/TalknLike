//
//  LoginView.swift
//  TalknLike
//
//  Created by 이상수 on 7/14/25.
//

import UIKit

final class LoginView: UIView {

    weak var delegate: LoginViewDelegate?

    let idField = UITextField()
    let passwordField = UITextField()
    let signUpButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .blue

        idField.placeholder = "실험용"
        idField.borderStyle = .roundedRect

        passwordField.placeholder = "비밀번호 (6자 이상)"
        passwordField.borderStyle = .roundedRect

        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.backgroundColor = .systemBlue
        signUpButton.tintColor = .white
        signUpButton.layer.cornerRadius = 8

        [idField, passwordField, signUpButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
//        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
           
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            idField.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            idField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            idField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            passwordField.topAnchor.constraint(equalTo: idField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: idField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: idField.trailingAnchor),

            signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            signUpButton.leadingAnchor.constraint(equalTo: idField.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: idField.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func loginTapped() {
        delegate?.didTapLoginButton()
    }
    
    @objc private func signUpTapped() {
        delegate?.didTapSignUpButton()
    }
    
}

