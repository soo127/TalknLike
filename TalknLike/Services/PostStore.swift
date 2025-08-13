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

    func loadPosts(for uid: String) async throws {
        let posts = try await Firestore.firestore()
            .collection("Posts")
            .whereField("uid", isEqualTo: uid)
            .order(by: "createdAt", descending: true)
            .getDocuments()
            .documents
            .compactMap {
                var post = try $0.data(as: Post.self)
                post.documentID = $0.documentID
                return post
            }
        postsSubject.send(posts)
    }
    
    func post(content: String?) async throws {
        guard let uid = CurrentUserStore.shared.currentUser?.uid,
              let content else {
            return
        }
        var newPost = Post(
            uid: uid,
            content: content,
            createdAt: Date()
        )
        let docRef = try Firestore.firestore()
            .collection("Posts")
            .addDocument(from: newPost)
        
        newPost.documentID = docRef.documentID
        let updated = [newPost] + postsSubject.value
        postsSubject.send(updated)
    }

    func deletePost(documentID: String) async throws {
        try await Firestore.firestore()
            .collection("Posts")
            .document(documentID)
            .delete()
        
        var currentPosts = postsSubject.value
        currentPosts.removeAll { $0.documentID == documentID }
        postsSubject.send(currentPosts)
    }
    
    func updatePost(documentID: String, newContent: String?) async throws {
        guard let newContent else {
            return
        }
        let date = Date()
        try await Firestore.firestore()
            .collection("Posts")
            .document(documentID)
            .updateData([
                "content": newContent,
                "createdAt": date
            ])
        
        var currentPosts = postsSubject.value
        currentPosts.firstIndex(where: { $0.documentID == documentID })
            .handleSome {
                let oldPost = currentPosts[$0]
                let updatedPost = Post(
                    documentID: oldPost.documentID,
                    uid: oldPost.uid,
                    content: newContent,
                    createdAt: date
                )
                currentPosts[$0] = updatedPost
                postsSubject.send(currentPosts)
            }
    }
    
}

extension PostStore {
    
    func getFollowingFeed(for profiles: [UserProfile]) async throws -> [FeedItem] {
        guard !profiles.isEmpty else {
            return []
        }
        let profileMap = Dictionary(uniqueKeysWithValues: profiles.map { ($0.uid, $0) })
        
        return try await Firestore.firestore()
            .collection("Posts")
            .whereField("uid", in: Array(profileMap.keys))
            .order(by: "createdAt", descending: true)
            .getDocuments()
            .documents
            .compactMap { document in
                var post = try document.data(as: Post.self)
                post.documentID = document.documentID
                guard let profile = profileMap[post.uid] else { return nil }
                return FeedItem(post: post, profile: profile)
            }
    }


}
