//
//  CurrentUserStore.swift
//  TalknLike
//
//  Created by 이상수 on 7/23/25.
//

import Combine
import FirebaseAuth
import FirebaseFirestore

final class CurrentUserStore {

    static let shared = CurrentUserStore()
    private let userSubject = CurrentValueSubject<UserProfile?, Never>(nil)

    var userPublisher: AnyPublisher<UserProfile, Never> {
        userSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    func fetchCurrentUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let userProfile = try? await Firestore.firestore()
            .collection("Users")
            .document(uid)
            .getDocument()
            .data(as: UserProfile.self)
        userSubject.send(userProfile)
    }
    
    func update(nickname: String? = nil,
                 bio: String? = nil,
                 photoURL: String? = nil) async throws {
        guard let uid = Auth.auth().currentUser?.uid,
              var user = userSubject.value else {
            return
        }
        
        if let nickname = nickname {
            user.nickname = nickname
        }
        if let bio = bio {
            user.bio = bio
        }
        if let photoURL = photoURL {
            user.photoURL = photoURL
        }

        try await Firestore.firestore()
            .collection("Users")
            .document(uid)
            .setData(user.asDictionary(), merge: true)

        userSubject.send(user)
    }
    
    var currentUser: UserProfile? {
        userSubject.value
    }

}
