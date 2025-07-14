//
//  User.swift
//  TalknLike
//
//  Created by 이상수 on 7/14/25.
//

import Foundation

struct User {
    let email: String
    let password: String
}

struct UserValidator {
    
    static func isValid(email: String, password: String) -> Bool {
        return email.contains("@") && password.count >= 6
    }
    
}
