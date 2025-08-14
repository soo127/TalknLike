//
//  FirestoreService.swift
//  TalknLike
//
//  Created by 이상수 on 8/12/25.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    
    static private let db = Firestore.firestore()
    
    static func fetchDocuments<T: Decodable>(
        for collection: FollowCollection,
        uid: String,
        type: T.Type
    ) async throws -> [T] {
        return try await db.collection("Users")
            .document(uid)
            .collection(collection.rawValue)
            .getDocuments()
            .documents
            .compactMap { try? $0.data(as: type.self) }
    }

    static func getReference(
        for collection: FollowCollection,
        userUid: String,
        myUid: String) -> DocumentReference {
            switch collection {
            case .acceptFollowRequests, .followers:
                return db.collection("Users")
                    .document(myUid)
                    .collection(collection.rawValue)
                    .document(userUid)
            case .followRequests, .following:
                return db.collection("Users")
                    .document(userUid)
                    .collection(collection.rawValue)
                    .document(myUid)
            }
        }
    
    static func acceptFollowRequest(userUid: String, myUid: String) async throws {
        let batch = db.batch()
        
        let requestRef = getReference(for: .followRequests, userUid: userUid, myUid: myUid)
        let followersRef = getReference(for: .followers, userUid: userUid, myUid: myUid)
        let followingRef = getReference(for: .following, userUid: userUid, myUid: myUid)
        batch.deleteDocument(requestRef)
        batch.setData(FollowMetadata.make(uid: userUid), forDocument: followersRef)
        batch.setData(FollowMetadata.make(uid: myUid), forDocument: followingRef)
        
        try await batch.commit()
    }
    
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

}

extension FirestoreService {
    
    enum FollowCollection: String {
        case followRequests = "followRequests"
        case acceptFollowRequests = "acceptFollowRequests"
        case followers = "followers"
        case following = "following"
    }
    
}
