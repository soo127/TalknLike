//
//  PostStore.swift
//  TalknLike
//
//  Created by 이상수 on 8/5/25.
//

import Combine
import FirebaseFirestore

final class PostStore {
    
    static let shared = PostStore()
    private let postsSubject = CurrentValueSubject<[Post], Never>([])

    var postsPublisher: AnyPublisher<[Post], Never> {
        postsSubject.eraseToAnyPublisher()
    }

    func fetchPosts(for uid: String) async throws {
        let posts = try await Firestore.firestore()
            .collection("Posts")
            .whereField("uid", isEqualTo: uid)
            .order(by: "createdAt", descending: true)
            .getDocuments()
            .documents
            .compactMap {
                try? $0.data(as: Post.self)
            }
        postsSubject.send(posts)
    }
    
}
