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
    let verifyButton = UIButton(type: .system)
    let certificationField = UITextField.make("인증번호 입력", numberOnly: true)
    let submitButton = UIButton(type: .system)
    
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
            
        title.text = "아이디 찾기"
        title.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        title.textAlignment = .left
        title.textColor = .black
        
        verifyButton.setTitle("인증", for: .normal)
        verifyButton.backgroundColor = .systemGray2
        verifyButton.layer.cornerRadius = 3
        verifyButton.setTitleColor(.white, for: .normal)
        
        submitButton.setTitle("확인", for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.tintColor = .white
        submitButton.layer.cornerRadius = 8
        submitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
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

