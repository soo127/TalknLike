//
//  FindIdView.swift
//  TalknLike
//
//  Created by 이상수 on 7/14/25.
//

import UIKit

final class FindIdView: UIView {

    let title = UILabel()
    let phoneField = UITextField.make("전화번호", numberOnly: true)
    let verifyButton = UIButton.make("인증", backgroundColor: .systemGray2)
    let certificationField = UITextField.make("인증번호 입력", numberOnly: true)
    let submitButton = UIButton.make("확인", backgroundColor: .systemBlue, height: 44)
    private lazy var phoneStack = UIStackView.make(views: [phoneField, verifyButton], axis: .horizontal, distribution: .fillProportionally)

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
            
        title.text = "아이디 찾기"
        title.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        title.textAlignment = .left
        title.textColor = .black

        submitButton.isEnabled = false
        submitButton.alpha = 0.5
    }

    private func setupConstraints() {
        [title, phoneField, verifyButton, submitButton, certificationField].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let stack = UIStackView(arrangedSubviews: [
            title,
            phoneStack,
            certificationField,
            submitButton
        ])
        stack.axis = .vertical
        stack.spacing = 10
        stack.setCustomSpacing(40, after: title)
        stack.setCustomSpacing(40, after: certificationField)
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            phoneField.widthAnchor.constraint(equalTo: phoneStack.widthAnchor, multiplier: 0.7)
        ])
    }
    
}

