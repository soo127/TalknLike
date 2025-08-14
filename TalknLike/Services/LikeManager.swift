//
//  LikeManager.swift
//  TalknLike
//
//  Created by 이상수 on 8/14/25.
//

import Foundation
import FirebaseFirestore

enum LikeManager {
    
    private static let db = Firestore.firestore()
    
    static func handleLike(postID: String, userID: String, isLiked: Bool) async throws {
        if isLiked {
            try await addLike(postID: postID, userID: userID)
        } else {
            try await removeLike(postID: postID, userID: userID)
        }
    }
    
    private static func addLike(postID: String, userID: String) async throws {
        let newLikeData: [String: Any] = [
            "uid": userID,
            "date": Date()
        ]
        try await db.collection("Posts")
            .document(postID)
            .collection("likes")
            .addDocument(data: newLikeData)
    }
    
    private static func removeLike(postID: String, userID: String) async throws {
        let likesRef = db.collection("Posts")
            .document(postID)
            .collection("likes")
        
        try await likesRef
            .whereField("uid", isEqualTo: userID)
            .getDocuments()
            .documents.first
            .handleSome {
                likesRef.document($0.documentID).delete()
            }
    }
    
    static func isLiked(postID: String, userID: String) async throws -> Bool {
        return try await !db.collection("Posts")
            .document(postID)
            .collection("likes")
            .whereField("uid", isEqualTo: userID)
            .getDocuments()
            .documents
            .isEmpty
    }

}
