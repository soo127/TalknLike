//
//  UIButton+Extension.swift
//  TalknLike
//
//  Created by 이상수 on 7/15/25.
//

import UIKit

extension UIButton {
    
    static func make(_ title: String,
                     backgroundColor: UIColor? = nil,
                     tintColor: UIColor = .white,
                     height: CGFloat? = nil
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.tintColor = tintColor
        button.layer.cornerRadius = 8
        if let backgroundColor {
            button.backgroundColor = backgroundColor
        }
        if let height {
            button.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        return button
    }
    
}
