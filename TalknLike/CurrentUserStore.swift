//
//  CurrentUserStore.swift
//  TalknLike
//
//  Created by 이상수 on 7/23/25.
//

import UIKit
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

    private init() {
        Task {
            await fetchCurrentUser()
        }
    }

    func fetchCurrentUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            let userProfile = try await Firestore.firestore()
                .collection("Users")
                .document(uid)
                .getDocument()
                .data(as: UserProfile.self)
            userSubject.send(userProfile)
        } catch {
            print("fetchCurrentUser error: \(error)")
        }
    }
    
    func update(nickname: String?, bio: String?) async throws {
        guard let nickname,
              let bio,
              let uid = Auth.auth().currentUser?.uid else {
            return
        }

        guard var user = userSubject.value else {
            return
        }
        user.nickname = nickname
        user.bio = bio

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
