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
        setupTitle()
        setupSubmitButton()
        setupPhone()
        setupLayout()
    }

}

extension FindIdView {
    
    private func setupTitle() {
        title.text = "아이디 찾기"
        title.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        title.textAlignment = .left
        title.textColor = .black
    }
    
    private func setupSubmitButton() {
        submitButton.isEnabled = false
        submitButton.alpha = 0.5
    }
    
    private func setupPhone() {
        phoneStack = UIStackView.make(
            views: [phoneField, verifyButton],
            axis: .horizontal,
            distribution: .fillProportionally
        )
        phoneField.widthAnchor.constraint(equalTo: phoneStack.widthAnchor, multiplier: 0.7).isActive = true
    }

    private func setupLayout() {
        let stack = UIStackView.make(
            views: [title, phoneStack, certificationField, submitButton],
            axis: .vertical,
            spacing: 10
        )
        stack.setCustomSpacing(40, after: title)
        stack.setCustomSpacing(40, after: certificationField)

        addSubview(stack)
        stack.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 100, left: 30, bottom: 0, right: 30)
        )
    }
    
}
