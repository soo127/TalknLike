//
//  IdCheckView.swift
//  TalknLike
//
//  Created by 이상수 on 7/15/25.
//

import UIKit

final class IdCheckView: UIView {
    
    private let stepIndicator = StepIndicatorView()
    let title = UILabel()
    let idField = UITextField.make("아이디 입력")
    let nextButton = UIButton.make("다음", backgroundColor: .systemBlue, height: 44)

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
        
        title.text = "아이디를 입력해주세요."
        title.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        title.textAlignment = .left
        title.textColor = .black

        let vStack = UIStackView(arrangedSubviews: [title, idField, nextButton])
        vStack.axis = .vertical
        vStack.spacing = 20
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.setCustomSpacing(50, after: title)
        addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: stepIndicator.bottomAnchor, constant: 150),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])
    }

}
