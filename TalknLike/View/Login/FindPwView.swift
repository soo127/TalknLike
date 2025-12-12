//
//  FindPwView.swift
//  TalknLike
//
//  Created by 이상수 on 7/15/25.
//

import UIKit

final class FindPwView: UIView {
    
    private let title = UILabel()
    let emailField = UITextField.make("이메일 입력")
    let okButton = UIButton.make("확인", backgroundColor: .systemBlue, height: 44)

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
        setupLayout()
    }

}

extension FindPwView {

    private func setupTitle() {
        title.text = "이메일을 입력해주세요."
        title.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        title.textAlignment = .left
        title.textColor = .black
    }
    
    private func setupLayout() {
        let stack = UIStackView.make(
            views: [title, emailField, okButton],
            axis: .vertical,
            spacing: 20
        )
        stack.setCustomSpacing(50, after: title)
        
        addSubview(stack)
        stack.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 150, left: 30, bottom: 0, right: 30)
        )
    }

}
