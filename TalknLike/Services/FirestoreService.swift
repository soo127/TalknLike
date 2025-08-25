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
    
    static func fetchProfile(uid: String) async throws -> UserProfile {
        return try await Firestore.firestore()
            .collection("Users")
            .document(uid)
            .getDocument(as: UserProfile.self)
    }
    
    static func fetchProfiles(uids: [String]) async throws -> [String: UserProfile] {
        var result: [String: UserProfile] = [:]
        try await withThrowingTaskGroup(of: (String, UserProfile).self) { group in
            for uid in uids {
                group.addTask {
                    let profile = try await fetchProfile(uid: uid)
                    return (uid, profile)
                }
            }
            for try await (uid, profile) in group {
                result[uid] = profile
            }
        }
        return result
    }

    
    static func fetchDocuments<T: Decodable>(
        for collection: FollowCollection,
        uid: String,
        type: T.Type
    ) async throws -> [T] {
        return try await db.collection("Users")
            .document(uid)
            .collection(collection.name)
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
                    .collection(collection.name)
                    .document(userUid)
            case .followRequests, .following:
                return db.collection("Users")
                    .document(userUid)
                    .collection(collection.name)
                    .document(myUid)
            }
        }
    
    static func acceptFollowRequest(userUid: String, myUid: String) async throws {
        let batch = db.batch()
        
        let requestRef = getReference(for: .acceptFollowRequests, userUid: userUid, myUid: myUid)
        let followersRef = getReference(for: .followers, userUid: userUid, myUid: myUid)
        let followingRef = getReference(for: .following, userUid: userUid, myUid: myUid)
        batch.deleteDocument(requestRef)
        batch.setData(FollowMetadata.make(uid: userUid), forDocument: followersRef)
        batch.setData(FollowMetadata.make(uid: myUid), forDocument: followingRef)
        
        try await batch.commit()
    }
    
}

extension FirestoreService {
    
    enum FollowCollection {
        case followRequests
        case acceptFollowRequests
        case followers
        case following
        
        var name: String {
            switch self {
            case .followRequests, .acceptFollowRequests:
                return "followRequests"
            case .followers:
                return "followers"
            case .following:
                return "following"
            }
        }
    }
    
}
