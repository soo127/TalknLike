//
//  StepIndicatorView.swift
//  TalknLike
//
//  Created by 이상수 on 7/15/25.
//

import UIKit

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
    
    func updateStep(index: Int) {
        for (i, label) in labels.enumerated() {
            label.textColor = i == index ? .systemBlue : .gray
        }
    }

}
