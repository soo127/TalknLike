//
//  LoginView.swift
//  TalknLike
//
//  Created by 이상수 on 7/14/25.
//

import UIKit

final class LoginView: UIView {

    weak var delegate: LoginViewDelegate?

    private let logoLabel = UILabel()
    private let idField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let signUpButton = UIButton(type: .system)
    private let findButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private func setup() {
        backgroundColor = .lightGray
        
        logoLabel.text = "TalknLike"
        logoLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        logoLabel.textAlignment = .center
        logoLabel.textColor = .white
        
        idField.placeholder = "아이디"
        idField.autocapitalizationType = .none
        idField.borderStyle = .roundedRect
        
        passwordField.placeholder = "비밀번호"
        passwordField.isSecureTextEntry = true
        passwordField.autocapitalizationType = .none
        passwordField.borderStyle = .roundedRect
        
        loginButton.setTitle("로그인", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.tintColor = .white
        loginButton.layer.cornerRadius = 8
        loginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.tintColor = .white
        
        findButton.setTitle("아이디/비밀번호 찾기", for: .normal)
        findButton.tintColor = .white
        
        let horizontalStackView = UIStackView(arrangedSubviews: [signUpButton, findButton])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        
        let verticalStackView = UIStackView(arrangedSubviews: [logoLabel, idField, passwordField, loginButton, horizontalStackView])
        verticalStackView.setCustomSpacing(50, after: logoLabel)
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 20
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        ])
        
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
    
}

extension LoginView {
    
    @objc private func loginTapped() {
        delegate?.didTapLoginButton()
    }
    
    @objc private func signUpTapped() {
        delegate?.didTapSignUpButton()
    }
    
    @objc private func findTapped() {
        delegate?.didTapFindButton()
    }

}
