//
//  FirestoreManager.swift
//  TalknLike
//
//  Created by 이상수 on 8/4/25.
//

import FirebaseFirestore

enum FirestoreManager {
    
    private static var firestore = Firestore.firestore()
    
    private static func initialUserData(uid: String, email: String) -> [String: Any] {
        return [
            "uid": uid,
            "nickname": "닉네임",
            "bio": "자기소개를 작성해보세요.",
            "photoURL": "person.fill",
            "email": email
        ]
    }
    
    static func post(content: String) async throws {
        try await CurrentUserStore.shared.currentUser
            .handleSome {
                try await firestore
                    .collection("Posts")
                    .addDocument(data: [
                        "profile": $0.asDictionary(),
                        "content": content,
                        "createdAt": Date()
                    ])
            }
    }
    
    static func registerUser(uid: String, email: String) async throws {
        try await firestore.collection("Users")
            .document(uid)
            .setData(initialUserData(uid: uid, email: email))
    }
    
    static func checkAvailable(email: String) async throws -> Bool {
        try await firestore.collection("Users")
            .whereField("email", isEqualTo: email)
            .getDocuments()
            .documents
            .isEmpty
    }
    
}
