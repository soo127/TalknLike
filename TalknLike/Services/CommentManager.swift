//
//  CommentManager.swift
//  TalknLike
//
//  Created by 이상수 on 8/15/25.
//

import Combine
import FirebaseFirestore

final class CommentManager {
    
    static let shared = CommentManager()
    
    private let commentsSubject = CurrentValueSubject<[Comment], Never>([])
    var commentsPublisher: AnyPublisher<[Comment], Never> {
        commentsSubject.eraseToAnyPublisher()
    }
    
    func fetchComments(postID: String) async throws {
        let comments = try await Firestore.firestore()
            .collection("Posts")
            .document(postID)
            .collection("comments")
            .order(by: "createdAt", descending: false)
            .getDocuments()
            .documents
            .compactMap {
                var data = try $0.data(as: Comment.self)
                data.documentID = $0.documentID
                return data
            }
        commentsSubject.send(comments)
    }
    
    func addComment(postID: String, content: String, parentID: String?, replyTo replyingID: String?) async throws {
        guard let uid = CurrentUserStore.shared.currentUser?.uid else {
            return
        }
        var newComment = Comment(
            postID: postID,
            uid: uid,
            content: content,
            createdAt: Date(),
            parentID: parentID,
            replyingToID: replyingID
        )
        
        let ref = Firestore.firestore()
            .collection("Posts")
            .document(postID)
            .collection("comments")
            .document()
        
        newComment.documentID = ref.documentID
        try ref.setData(from: newComment)
        
        var current = commentsSubject.value
        current.append(newComment)
        commentsSubject.send(current)
    }
    
    func deleteComment(comment: Comment) async throws {
        guard let docID = comment.documentID else {
            return
        }
        try await Firestore.firestore()
            .collection("Posts")
            .document(comment.postID)
            .collection("comments")
            .document(docID)
            .delete()
 
        var current = commentsSubject.value
        current.removeAll { $0.documentID == docID }
        commentsSubject.send(current)
    }
    
    func makeDisplayOrder(comments: [Comment]) -> [Comment] {
        let roots = comments.filter { $0.parentID == nil }
        let replies = comments.filter { $0.parentID != nil }
        let repliesByParent = Dictionary(grouping: replies, by: { $0.parentID! })
        
        var display: [Comment] = []
        for root in roots.sorted(by: { $0.createdAt < $1.createdAt }) {
            display.append(root)
            if let children = repliesByParent[root.documentID ?? ""] {
                display.append(contentsOf: children.sorted(by: { $0.createdAt < $1.createdAt }))
            }
        }
        return display
    }
    
}

extension CommentManager {
    
    func mergeWithProfiles(comments: [Comment]) async throws -> [CommentDisplayModel] {
        guard !comments.isEmpty else {
            return []
        }
        let profiles = try await Firestore.firestore()
            .collection("Users")
            .whereField("uid", in: comments.map { $0.uid })
            .getDocuments()
            .documents
            .compactMap { document in
                try? document.data(as: UserProfile.self)
            }

        let profileMap = Dictionary(uniqueKeysWithValues: profiles.map { ($0.uid, $0) })

        let result = comments.compactMap { comment -> CommentDisplayModel? in
            guard let profile = profileMap[comment.uid] else {
                return nil
            }
            return CommentDisplayModel(comment: comment, profile: profile)
        }
        return result
    }
    
}
