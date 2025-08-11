//
//  UIView+Extension.swift
//  TalknLike
//
//  Created by 이상수 on 8/1/25.
//

import UIKit

extension UIView {
    
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        padding: UIEdgeInsets = .zero,
        width: Double = .zero,
        height: Double = .zero,
        centerX: NSLayoutXAxisAnchor? = nil,
        centerY: NSLayoutYAxisAnchor? = nil
    ) {
        translatesAutoresizingMaskIntoConstraints = false

        if let top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }

        if let leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }

        if let bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }

        if let trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }

        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }

        if let centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
    
    func anchor(
        centerX: NSLayoutXAxisAnchor? = nil,
        centerY: NSLayoutYAxisAnchor? = nil
    ) {
        translatesAutoresizingMaskIntoConstraints = false

        if let centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }

        if let centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
    
}
