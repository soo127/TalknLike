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
    
    static func handleLike(postID: String, userID: String, isLiked: Bool) async {
        do {
            if isLiked {
                try await addLike(postID: postID, userID: userID)
            } else {
                try await removeLike(postID: postID, userID: userID)
            }
        } catch {
            print("error in LikeManager: \(error)")
        }
    }
    
    private static func addLike(postID: String, userID: String) async throws {
        let batch = db.batch()
        let newLikeData: [String: Any] = [
            "uid": userID,
            "date": Date()
        ]
        let postRef = db.collection("Posts").document(postID)
        let likeRef = postRef.collection("likes").document()
        
        batch.setData(newLikeData, forDocument: likeRef)
        batch.updateData(["likeCount": FieldValue.increment(Int64(1))], forDocument: postRef)
        try await batch.commit()
    }
    
    private static func removeLike(postID: String, userID: String) async throws {
        let batch = db.batch()

        try await db.collection("Posts")
            .document(postID)
            .collection("likes")
            .whereField("uid", isEqualTo: userID)
            .getDocuments()
            .documents.first
            .handleSome {
                batch.deleteDocument($0.reference)
            }

        let postRef = db.collection("Posts").document(postID)
        batch.updateData(["likeCount": FieldValue.increment(Int64(-1))], forDocument: postRef)
        try await batch.commit()
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
