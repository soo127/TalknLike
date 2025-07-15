//
//  UIStackView+Extension.swift
//  TalknLike
//
//  Created by 이상수 on 7/15/25.
//

import UIKit

extension UIStackView {
    
    static func horizontalStack(
        views: [UIView],
        spacing: CGFloat = 8,
        distribution: UIStackView.Distribution = .fillProportionally
    ) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .horizontal
        stack.spacing = spacing
        stack.distribution = distribution
        return stack
    }
    
}

