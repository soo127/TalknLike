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
    
}
