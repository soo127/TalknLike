//
//  FirestoreManager.swift
//  TalknLike
//
//  Created by 이상수 on 8/4/25.
//

import FirebaseFirestore

// Login Manager로 이름 변경 고려
enum FirestoreManager {
    
    private static var firestore = Firestore.firestore()

    static func registerUser(uid: String, email: String) async throws {
        let newUser = UserProfile.initial(uid: uid, email: email)
        try firestore.collection("Users")
            .document(uid)
            .setData(from: newUser)
    }
    
    static func checkAvailable(email: String) async throws -> Bool {
        try await firestore.collection("Users")
            .whereField("email", isEqualTo: email)
            .getDocuments()
            .documents
            .isEmpty
    }
    
}
