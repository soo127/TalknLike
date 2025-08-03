//
//  PhoneVerifyView.swift
//  TalknLike
//
//  Created by 이상수 on 7/15/25.
//

import UIKit

final class PhoneVerifyView: UIView {

    private let stepIndicator = StepIndicatorView()
    let title = UILabel()
    let phoneField = UITextField.make("전화번호", numberOnly: true)
    let verifyButton = UIButton.make("인증", backgroundColor: .systemGray2)
    let codeField = UITextField.make("인증번호 입력", numberOnly: true)
    let nextButton = UIButton.make("다음", backgroundColor: .systemBlue, height: 44)
    private lazy var phoneStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        setupStepIndicator()
        setupTitle()
        setupPhoneStack()
        setupLayout()
    }

}

extension PhoneVerifyView {
    
    private func setupStepIndicator() {
        addSubview(stepIndicator)
        stepIndicator.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            height: 40,
        )
    }
    
    private func setupTitle() {
        title.text = "번호 인증을 완료해주세요."
        title.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        title.textAlignment = .left
        title.textColor = .black
    }
    
    private func setupPhoneStack() {
        phoneStack = UIStackView.make(
            views: [phoneField, verifyButton],
            axis: .horizontal,
            distribution: .fillProportionally
        )
    }
    
    private func setupLayout() {
        let stack = UIStackView.make(
            views: [title, phoneStack, codeField, nextButton],
            axis: .vertical,
            spacing: 20
        )
        stack.setCustomSpacing(50, after: title)
        
        addSubview(stack)
        stack.anchor(
            top: safeAreaLayoutGuide.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 150, left: 30, bottom: 0, right: 30)
        )
    }
    
}
