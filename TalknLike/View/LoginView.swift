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
    private let idField = UITextField.make("아이디")
    private let passwordField = UITextField.make("비밀번호", secure: true)
    private let loginButton = UIButton.make("로그인", backgroundColor: .systemBlue, height: 44)
    private let signUpButton = UIButton.make("회원가입")
    private let findIdButton = UIButton.make("아이디 찾기")
    private let findPwButton = UIButton.make("비밀번호 찾기")
    
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
        
        let hStack = UIStackView(arrangedSubviews: [signUpButton, findIdButton, findPwButton])
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        
        let vStack = UIStackView(arrangedSubviews: [logoLabel, idField, passwordField, loginButton, hStack])
        vStack.setCustomSpacing(50, after: logoLabel)
        vStack.axis = .vertical
        vStack.spacing = 20
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        ])
        
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        findIdButton.addTarget(self, action: #selector(findIdTapped), for: .touchUpInside)
        findPwButton.addTarget(self, action: #selector(findPwTapped), for: .touchUpInside)
    }
    
}

extension LoginView {
    
    @objc private func loginTapped() {
        delegate?.didTapLoginButton()
    }
    
    @objc private func signUpTapped() {
        delegate?.didTapSignUpButton()
    }
    
    @objc private func findIdTapped() {
        delegate?.didTapFindIdButton()
    }
    
    @objc private func findPwTapped() {
        delegate?.didTapFindPwButton()
    }

}
