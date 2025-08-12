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
        try await FirestoreService
            .getReference(for: .followRequests, userUid: user.uid, myUid: currentUser.uid)
            .setData(FollowMetadata.make(uid: currentUser.uid))
    }
    
    func acceptFollowRequest(for user: UserProfile) async throws {
        guard let currentUser = CurrentUserStore.shared.currentUser else {
            return
        }
        try await FirestoreService.acceptFollowRequest(userUid: user.uid, myUid: currentUser.uid)
        
        var currentRequests = followRequestsSubject.value
        currentRequests.removeAll { $0.uid == user.uid }
        followRequestsSubject.send(currentRequests)
        
        var currentFollowers = followersSubject.value
        currentFollowers.append(user)
        followersSubject.send(currentFollowers)
    }
    
}

extension FollowManager {

    func fetchFollowRequests(for uid: String) async throws {
        let metaDataList = try await FirestoreService
            .fetchDocuments(
                for: .followRequests,
                uid: uid,
                type: FollowMetadata.self
            )
        let requests = try await fetchProfiles(metaDataList: metaDataList)
        followRequestsSubject.send(requests)
    }
    
    func fetchFollowers(for uid: String) async throws {
        let metaDataList = try await FirestoreService
            .fetchDocuments(
                for: .followers,
                uid: uid,
                type: FollowMetadata.self
            )
        let followers = try await fetchProfiles(metaDataList: metaDataList)
        followersSubject.send(followers)
    }
    
    func fetchFollowings(for uid: String) async throws {
        let metaDataList = try await FirestoreService
            .fetchDocuments(
                for: .following,
                uid: uid,
                type: FollowMetadata.self
            )
        let followings = try await fetchProfiles(metaDataList: metaDataList)
        followingsSubject.send(followings)
    }
    
    private func fetchProfiles(metaDataList: [FollowMetadata]) async throws -> [UserProfile] {
        try await withThrowingTaskGroup(of: UserProfile.self) { group in
            for metaData in metaDataList {
                group.addTask {
                    try await Firestore.firestore()
                        .collection("Users")
                        .document(metaData.uid)
                        .getDocument(as: UserProfile.self)
                }
            }
            return try await group.reduce(into: []) { $0.append($1) }
        }
    }
    
}
