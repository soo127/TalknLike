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
        labels = titles.map { title in
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 14, weight: .medium)
            label.textColor = .gray
            return label
        }
        
        let stack = UIStackView.make(
            views: labels,
            axis: .horizontal,
            distribution: .fillEqually
        )
        stack.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor
        )
    }
    
}
