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
    let emailField = UITextField.make("이메일")
    let passwordField = UITextField.make("비밀번호", secure: true)
    private let loginButton = UIButton.make("로그인", backgroundColor: .systemBlue, height: 44)
    private let signUpButton = UIButton.make("회원가입")
    private let findPwButton = UIButton.make("비밀번호를 잊으셨나요?")
    private var menuButtons = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupLogoLabel()
        setupButtonActions()
        setupMenus()
        setupLayout()
    }
    
}

extension LoginView {
    
    private func setupLogoLabel() {
        logoLabel.text = "TalknLike"
        logoLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        logoLabel.textAlignment = .center
        logoLabel.textColor = .white
    }
    
    func setupButtonActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        findPwButton.addTarget(self, action: #selector(findPwTapped), for: .touchUpInside)
    }
   
    private func setupMenus() {
        menuButtons = UIStackView.make(
            views: [signUpButton, findPwButton],
            axis: .horizontal,
            distribution: .fillEqually
        )
    }
    
    private func setupLayout() {
        let stack = UIStackView.make(
            views: [logoLabel, emailField, passwordField, loginButton, menuButtons],
            axis: .vertical,
            spacing: 20
        )
        stack.setCustomSpacing(50, after: logoLabel)
        
        addSubview(stack)
        stack.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 100, left: 40, bottom: 0, right: 40)
        )
    }
    
}

extension LoginView {
    
    @objc private func loginTapped() {
        delegate?.didTapButton(.login)
    }
    
    @objc private func signUpTapped() {
        delegate?.didTapButton(.signUp)
    }
    
    @objc private func findPwTapped() {
        delegate?.didTapButton(.findPw)
    }

}
