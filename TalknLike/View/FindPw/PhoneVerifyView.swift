//
//  PhoneVerifyView.swift
//  TalknLike
//
//  Created by 이상수 on 7/15/25.
//

import UIKit

final class PhoneVerifyView: UIView, StepView {

    var onNext: (() -> Void)?
    
    private let stepIndicator = StepIndicatorView()
    let title = UILabel()
    let phoneField = UITextField.make("전화번호", numberOnly: true)
    let verifyButton = UIButton.make("인증", backgroundColor: .systemGray2)
    let codeField = UITextField.make("인증번호 입력", numberOnly: true)
    let nextButton = UIButton.make("다음", backgroundColor: .systemBlue, height: 44)
    private lazy var phoneStack = UIStackView.make(views: [phoneField, verifyButton], axis: .horizontal)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .white
        
        stepIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stepIndicator)
        NSLayoutConstraint.activate([
            stepIndicator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stepIndicator.leadingAnchor.constraint(equalTo: leadingAnchor),
            stepIndicator.trailingAnchor.constraint(equalTo: trailingAnchor),
            stepIndicator.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        title.text = "번호 인증을 완료해주세요."
        title.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        title.textAlignment = .left
        title.textColor = .black
        
        nextButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [title, phoneStack, codeField, nextButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.setCustomSpacing(50, after: title)
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: stepIndicator.bottomAnchor, constant: 150),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
        ])
    }
    
}

extension PhoneVerifyView {
    
    @objc private func tapped() {
        onNext?()
    }
    
}
