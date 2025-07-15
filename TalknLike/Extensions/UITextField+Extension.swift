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
    
}
