//
//  UITextField+Extension.swift
//  TalknLike
//
//  Created by 이상수 on 7/15/25.
//

import UIKit

extension UITextField {
    
    static func make(_ placeholder: String,
                     secure: Bool = false,
                     numberOnly: Bool = false,
    ) -> UITextField {
        let field = UITextField()
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        if secure {
            field.isSecureTextEntry = true
        }
        if numberOnly {
            field.keyboardType = .numberPad
        }
        return field
    }
    
    func setLeftIcon(
        image: UIImage?,
        leftPadding: CGFloat,
        rightPadding: CGFloat,
        iconSize: CGFloat = 23
    ) {
        let l = leftPadding, r = rightPadding
        let size = min(iconSize, 23)
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: l+r+size, height: size))
        let imageView = UIImageView(image: image)
        imageView.tintColor = .systemGray
        imageView.frame = CGRect(x: l, y: 0, width: size, height: size)
        imageView.center.y = container.center.y
        container.addSubview(imageView)
        
        leftView = container
        leftViewMode = .always
    }
    
    func setRightIcon(
        image: UIImage?,
        leftPadding: CGFloat,
        rightPadding: CGFloat,
        iconSize: CGFloat = 23
    ) {
        let l = leftPadding, r = rightPadding
        let size = min(iconSize, 23)
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: l+r+size, height: size))
        let imageView = UIImageView(image: image)
        imageView.tintColor = .systemGray
        imageView.frame = CGRect(x: l, y: 0, width: size, height: size)
        imageView.center.y = container.center.y
        container.addSubview(imageView)
        
        rightView = container
        rightViewMode = .always
    }
    
}
