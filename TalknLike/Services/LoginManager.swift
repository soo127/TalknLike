//
//  LoginManager.swift
//  TalknLike
//
//  Created by 이상수 on 8/4/25.
//

import FirebaseFirestore

enum LoginManager {
    
    private static var firestore = Firestore.firestore()

    static func registerUser(uid: String, email: String) async throws {
        let newUser = UserProfile.initial(uid: uid, email: email)
        try firestore.collection("Users")
            .document(uid)
            .setData(from: newUser)
    }

    static func checkEmailStatus(email: String) async throws -> EmailCheckResult {
        if email.isEmpty {
            return .empty
        }
        if !isValidFormat(email: email) {
            return .badFormat
        }
        let duplicated = try await isDuplicated(email: email)
        return duplicated ? .duplicate : .available
    }
    
    private static func isValidFormat(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
    
    private static func isDuplicated(email: String) async throws -> Bool {
        return try await !Firestore.firestore()
            .collection("Users")
            .whereField("email", isEqualTo: email)
            .getDocuments()
            .documents
            .isEmpty
    }
    
}

extension LoginManager {
    
    static func isValidPassword(password: String) -> Bool {
        guard password.count >= 8, password.count <= 10 else { return false }
        
        let hasUppercase = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: password)
        let hasLowercase = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: password)
        let hasNumber = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password)
        let hasSpecialChar = NSPredicate(format: "SELF MATCHES %@", ".*[!@#$%^&*(),.?\":{}|<>]+.*").evaluate(with: password)
        return hasUppercase && hasLowercase && hasNumber && hasSpecialChar
    }
    
}
