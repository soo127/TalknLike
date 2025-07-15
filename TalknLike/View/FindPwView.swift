//
//  FindPwView.swift
//  TalknLike
//
//  Created by 이상수 on 7/15/25.
//

import UIKit

final class FindPwView: UIView {

    let title = UILabel()
    let idField = UITextField()
    let nextButton = UIButton(type: .system)

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

        title.text = "비밀번호 찾기 - 아이디 확인"
        title.font = .boldSystemFont(ofSize: 24)
        title.textAlignment = .center

        idField.placeholder = "아이디"
        idField.borderStyle = .roundedRect
        idField.autocapitalizationType = .none

        nextButton.setTitle("다음", for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.tintColor = .white
        nextButton.layer.cornerRadius = 8
        nextButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    private func setupConstraints() {
        addSubview(StepIndicatorView())
        [title, idField, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),

            idField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 40),
            idField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            idField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),

            nextButton.topAnchor.constraint(equalTo: idField.bottomAnchor, constant: 40),
            nextButton.leadingAnchor.constraint(equalTo: idField.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: idField.trailingAnchor)
        ])
    }
}

final class StepIndicatorView: UIView {
    
    private let titles = ["아이디 입력", "전화번호 인증", "비밀번호 재설정"]
    private var labels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .systemGray6
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false

        for title in titles {
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            label.textColor = .gray
            labels.append(label)
            stack.addArrangedSubview(label)
        }

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
