//
//  PhoneVerifyView.swift
//  TalknLike
//
//  Created by 이상수 on 7/15/25.
//

import UIKit

final class PhoneVerifyView: UIView, StepView {

    var onNext: (() -> Void)?
    let phoneField = UITextField()
    let codeField = UITextField()
    let nextButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .white
        
        phoneField.placeholder = "전화번호 입력"
        phoneField.borderStyle = .roundedRect
        phoneField.keyboardType = .phonePad

        codeField.placeholder = "인증번호 입력"
        codeField.borderStyle = .roundedRect
        codeField.keyboardType = .numberPad

        nextButton.setTitle("다음", for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.tintColor = .white
        nextButton.layer.cornerRadius = 6
        nextButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [phoneField, codeField, nextButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            nextButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
}

extension PhoneVerifyView {
    
    @objc private func tapped() {
        onNext?()
    }
    
}
