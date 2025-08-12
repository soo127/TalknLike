//
//  FollowManager.swift
//  TalknLike
//
//  Created by 이상수 on 8/11/25.
//

import Combine
import FirebaseFirestore

final class FollowManager {
    
    static let shared = FollowManager()
    
    private let followRequestsSubject = CurrentValueSubject<[UserProfile], Never>([])
    var followRequestsPublisher: AnyPublisher<[UserProfile], Never> {
        followRequestsSubject.eraseToAnyPublisher()
    }
    
    private let followersSubject = CurrentValueSubject<[UserProfile], Never>([])
    var followersPublisher: AnyPublisher<[UserProfile], Never> {
        followersSubject.eraseToAnyPublisher()
    }
    
    private let followingsSubject = CurrentValueSubject<[UserProfile], Never>([])
    var followingsPublisher: AnyPublisher<[UserProfile], Never> {
        followingsSubject.eraseToAnyPublisher()
    }
    
}

extension FollowManager {
    
    func sendFollowRequest(to user: UserProfile) async throws {
        guard let currentUser = CurrentUserStore.shared.currentUser else {
            return
        }
        var data: [String: Any] = [
            "uid": currentUser.uid,
            "email": currentUser.email,
            "nickname": currentUser.nickname,
            //"date": Date()
        ]
        if let photoURL = currentUser.photoURL {
            data["photoURL"] = photoURL
        }

        try await Firestore.firestore()
            .collection("Users")
            .document(user.uid)
            .collection("followRequests")
            .document(currentUser.uid)
            .setData(data)
    }
    
    func fetchFollowRequests(for uid: String) async throws {
        let requests = try await Firestore.firestore()
            .collection("Users")
            .document(uid)
            .collection("followRequests")
            //.order(by: "date", descending: true)
            .getDocuments()
            .documents
            .compactMap {
                try? $0.data(as: UserProfile.self)
            }
        followRequestsSubject.send(requests)
    }
    
    func fetchFollowers(for uid: String) async throws {
        let followers = try await Firestore.firestore()
            .collection("Users")
            .document(uid)
            .collection("followers")
            .getDocuments()
            .documents
            .compactMap { try? $0.data(as: UserProfile.self) }
        followersSubject.send(followers)
    }
    
    func fetchFollowings(for uid: String) async throws {
        let followings = try await Firestore.firestore()
            .collection("Users")
            .document(uid)
            .collection("following")
            .getDocuments()
            .documents
            .compactMap { try? $0.data(as: UserProfile.self) }
        followingsSubject.send(followings)
    }
    
    func acceptFollowRequest(for user: UserProfile) async throws {
        guard let currentUser = CurrentUserStore.shared.currentUser else {
            return
        }
        
        let db = Firestore.firestore()
        let batch = db.batch()
        
        let requestRef = db.collection("Users")
            .document(currentUser.uid)
            .collection("followRequests")
            .document(user.uid)
        
        let followersRef = db.collection("Users")
            .document(currentUser.uid)
            .collection("followers")
            .document(user.uid)
        
        let followingRef = db.collection("Users")
            .document(user.uid)
            .collection("following")
            .document(currentUser.uid)
        
        batch.deleteDocument(requestRef)
        
        batch.setData([
            "uid": user.uid,
            "email": user.email,
            "nickname": user.nickname,
            //"date": Date()
        ], forDocument: followersRef)
        
        batch.setData([
            "uid": currentUser.uid,
            "email": currentUser.email,
            "nickname": user.nickname,
            //"date": Date()
        ], forDocument: followingRef)
        
        try await batch.commit()
        
        var currentRequests = followRequestsSubject.value
        currentRequests.removeAll { $0.uid == user.uid }
        followRequestsSubject.send(currentRequests)
                
        var currentFollowers = followersSubject.value
        currentFollowers.append(user)
        followersSubject.send(currentFollowers)
    }

}
