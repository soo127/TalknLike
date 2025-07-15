//
//  IdCheckView.swift
//  TalknLike
//
//  Created by 이상수 on 7/15/25.
//

import UIKit

final class IdCheckView: UIView, StepView {
    
    var onNext: (() -> Void)?

    let idField = UITextField()
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

        idField.placeholder = "아이디 입력"
        idField.borderStyle = .roundedRect
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.tintColor = .white
        nextButton.layer.cornerRadius = 6
        nextButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [idField, nextButton])
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

extension IdCheckView {
    
    @objc private func tapped() {
        onNext?()
    }
    
}
