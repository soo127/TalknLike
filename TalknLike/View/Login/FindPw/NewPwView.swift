//
//  NewPwView.swift
//  TalknLike
//
//  Created by 이상수 on 7/15/25.
//

import UIKit

final class NewPwView: UIView {
    
    private let stepIndicator = StepIndicatorView()
    let title = UILabel()
    let passwordField = UITextField.make("새 비밀번호", secure: true)
    let confirmField = UITextField.make("비밀번호 확인", secure: true)
    let finishButton = UIButton.make("완료", backgroundColor: .systemBlue, height: 44)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        setupIndicator()
        setupTitle()
        setupLayout()
    }
    
}

extension NewPwView {
    
    private func setupIndicator() {
        addSubview(stepIndicator)
        stepIndicator.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            height: 40
        )
    }
    
    private func setupTitle() {
        title.text = "비밀번호를 재설정합니다."
        title.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        title.textAlignment = .left
        title.textColor = .black
    }
    
    private func setupLayout() {
        let stack = UIStackView.make(
            views: [title, passwordField, confirmField, finishButton],
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
