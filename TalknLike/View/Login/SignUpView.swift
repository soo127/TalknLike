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
    let emailLabel = UILabel()

    private lazy var emailStack = UIStackView.make(views: [emailField, emailVerifyButton], axis: .horizontal)

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

        emailVerifyButton.isEnabled = false
        emailVerifyButton.alpha = 0.5
        
        emailLabel.font = UIFont.systemFont(ofSize: 12)
        emailLabel.numberOfLines = 1

        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        emailVerifyButton.addTarget(self, action: #selector(didTapVerifyButton), for: .touchUpInside)
    }

    private func setupConstraints() {
        let emailFieldGroup = UIStackView(arrangedSubviews: [
            makeField(icon: "envelope.fill", text: "이메일", field: emailStack),
            emailLabel
        ])
        emailFieldGroup.axis = .vertical
        emailFieldGroup.spacing = 4

        let stackView = UIStackView(arrangedSubviews: [
            emailFieldGroup,
            makeField(icon: "lock.fill", text: "비밀번호", field: passwordField),
            makeField(icon: "lock.fill", text: "비밀번호 확인", field: passwordCheckField),
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

        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailVerifyButton.translatesAutoresizingMaskIntoConstraints = false
        emailField.widthAnchor.constraint(equalTo: emailStack.widthAnchor, multiplier: 0.7).isActive = true
    }

    private func makeField(icon: String, text: String, field: UIView) -> UIStackView {
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .gray
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20)
        ])

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
        emailLabel.text = result.errorMessage
        emailLabel.textColor = result.isValid ? .systemGreen : .systemRed
    }
    
    func updateVerifyButton(result: EmailCheckResult) {
        emailVerifyButton.isEnabled = result.isValid
        emailVerifyButton.alpha = result.isValid ? 1.0 : 0.5
    }
    
}
