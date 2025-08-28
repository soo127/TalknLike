//
//  UIStackView+Extension.swift
//  TalknLike
//
//  Created by 이상수 on 7/15/25.
//

import UIKit

extension UIStackView {
    
    static func make(
        views: [UIView],
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 8,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill
    ) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = axis
        stack.spacing = spacing
        stack.distribution = distribution
        stack.alignment = alignment
        return stack
    }
    
}

