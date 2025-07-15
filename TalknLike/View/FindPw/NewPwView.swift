//
//  NewPwView.swift
//  TalknLike
//
//  Created by 이상수 on 7/15/25.
//

import UIKit

final class NewPwView: UIView, StepView {
    
    var onNext: (() -> Void)?
    
    private let stepIndicator = StepIndicatorView()
    let title = UILabel()
    let passwordField = UITextField.make("새 비밀번호", secure: true)
    let confirmField = UITextField.make("비밀번호 확인", secure: true)
    let finishButton = UIButton(type: .system)
    
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
        
        title.text = "비밀번호를 재설정합니다."
        title.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        title.textAlignment = .left
        title.textColor = .black
        
        finishButton.setTitle("완료", for: .normal)
        finishButton.backgroundColor = .systemBlue
        finishButton.tintColor = .white
        finishButton.layer.cornerRadius = 6
        finishButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [title, passwordField, confirmField, finishButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.setCustomSpacing(50, after: title)
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: stepIndicator.bottomAnchor, constant: 150),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            finishButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
}

extension NewPwView {
    
    @objc private func tapped() {
        onNext?()
    }
}
