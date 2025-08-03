//
//  SignUpView.swift
//  TalknLike
//
//  Created by 이상수 on 7/14/25.
//

import UIKit

final class SignUpView: UIView {
    
    weak var delegate: SignUpViewDelegate?

    let emailField = UITextField.make("이메일")
    let emailVerifyButton = UIButton.make("인증", backgroundColor: .systemGray2)
    let passwordField = UITextField.make("비밀번호 (8자 이상)", secure: true)
    let passwordCheckField = UITextField.make("비밀번호 확인", secure: true)
    let signUpButton = UIButton.make("가입", backgroundColor: .systemBlue, height: 44)
    private let emailMessageLabel = UILabel()

    private lazy var emailStack = UIStackView.make(views: [emailField, emailVerifyButton], axis: .horizontal)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .white
        setupEmail()
        setupSignupButton()
        setupLayout()
    }

}

extension SignUpView {

    private func setupEmail() {
        setupEmailLabel()
        setupEmailVerifyButton()
        emailField.widthAnchor.constraint(equalTo: emailStack.widthAnchor, multiplier: 0.7).isActive = true
    }
    
    private func setupSignupButton() {
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
    }
    
    private func setupEmailVerifyButton() {
        emailVerifyButton.isEnabled = false
        emailVerifyButton.alpha = 0.5
        emailVerifyButton.addTarget(self, action: #selector(didTapVerifyButton), for: .touchUpInside)
    }
    
    private func setupEmailLabel() {
        emailMessageLabel.font = UIFont.systemFont(ofSize: 12)
        emailMessageLabel.numberOfLines = 1
    }

    private func setupLayout() {
        let emailFieldGroup = UIStackView.make(
            views: [
                makeField(icon: "envelope.fill", text: "이메일", field: emailStack),
                emailMessageLabel
            ],
            axis: .vertical,
            spacing: 4
        )

        let stackView = UIStackView.make(
            views: [
                emailFieldGroup,
                makeField(icon: "lock.fill", text: "비밀번호", field: passwordField),
                makeField(icon: "lock.fill", text: "비밀번호 확인", field: passwordCheckField),
                signUpButton
            ],
            axis: .vertical,
            spacing: 20
        )

        addSubview(stackView)
        stackView.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 60, left: 30, bottom: 0, right: 30)
        )
    }
    
    private func makeField(icon: String, text: String, field: UIView) -> UIStackView {
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .gray
        iconView.anchor(width: 20, height: 20)
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        
        let titleStack = UIStackView.make(views: [iconView, label], axis: .horizontal)
        let mainStack = UIStackView.make(views: [titleStack, field], axis: .vertical)
        
        return mainStack
    }
    
}

// MARK: - Delegate Event 연결
extension SignUpView {
    
    @objc func didTapVerifyButton() {
        delegate?.didTapVerifyButton()
    }
    
    @objc func didTapSignUpButton() {
        delegate?.didTapSignUpButton()
    }
    
}

// MARK: - 외부에서 호출할 메서드들
extension SignUpView {
    
    func showEmailFieldMessage(result: EmailCheckResult) {
        emailMessageLabel.text = result.errorMessage
        emailMessageLabel.textColor = result.isValid ? .systemGreen : .systemRed
    }
    
    func updateVerifyButton(result: EmailCheckResult) {
        emailVerifyButton.isEnabled = result.isValid
        emailVerifyButton.alpha = result.isValid ? 1.0 : 0.5
    }
    
}
