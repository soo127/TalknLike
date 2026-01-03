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
    private var listener: ListenerRegistration?
    
    private let commentsSubject = CurrentValueSubject<[Comment], Never>([])
    var commentsPublisher: AnyPublisher<[Comment], Never> {
        commentsSubject.eraseToAnyPublisher()
    }

    func startObserving(postID: String) {
        listener = Firestore.firestore()
            .collection("Posts")
            .document(postID)
            .collection("comments")
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                
                let comments = documents.compactMap { doc -> Comment? in
                    guard var data = try? doc.data(as: Comment.self) else {
                        return nil
                    }
                    data.documentID = doc.documentID
                    return data
                }
                
                self?.commentsSubject.send(comments)
            }
    }
    
    func stopObserving() {
        listener?.remove()
        commentsSubject.send([])
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
    }
    
    func updateComment(comment: Comment, newContent: String) async throws {
        guard let docID = comment.documentID else {
            return
        }
        try await Firestore.firestore()
            .collection("Posts")
            .document(comment.postID)
            .collection("comments")
            .document(docID)
            .updateData([
                "content": newContent,
                "createdAt": Date()
            ])
    }
    
    func deleteComment(comment: Comment) async throws {
        guard let docID = comment.documentID else {
            return
        }
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                try await Firestore.firestore()
                    .collection("Posts")
                    .document(comment.postID)
                    .collection("comments")
                    .document(docID)
                    .delete()
            }
            
            let replies = commentsSubject.value.filter { $0.parentID == docID }
            for reply in replies {
                if let replyDocID = reply.documentID {
                    group.addTask {
                        try await Firestore.firestore()
                            .collection("Posts")
                            .document(comment.postID)
                            .collection("comments")
                            .document(replyDocID)
                            .delete()
                    }
                }
            }
            try await group.waitForAll()
        }
    }
    
    func makeDisplayOrder(comments: [Comment]) -> [Comment] {
        let roots = comments.filter { $0.parentID == nil }
        let replies = comments.filter { $0.parentID != nil }
        let repliesByParent = Dictionary(grouping: replies, by: { $0.parentID! })
        
        var display: [Comment] = []
        for root in roots.sorted(by: { $0.createdAt > $1.createdAt }) {
            display.append(root)
            if let children = repliesByParent[root.documentID ?? ""] {
                display.append(contentsOf: children.sorted(by: { $0.createdAt < $1.createdAt }))
            }
        }
        return display
    }
    
    func isMyComment(uid: String) -> Bool {
        guard let currentUser = CurrentUserStore.shared.currentUser else {
            return false
        }
        return currentUser.uid == uid
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

        let commentIDToNickname = Dictionary(uniqueKeysWithValues: comments.compactMap { comment in
            profileMap[comment.uid].map { (comment.documentID, $0.nickname) }
        })

        let result = comments.compactMap { comment -> CommentDisplayModel? in
            guard let profile = profileMap[comment.uid] else {
                return nil
            }
            let replyNickname = comment.replyingToID.flatMap { commentIDToNickname[$0] }
            return CommentDisplayModel(comment: comment, profile: profile, replyNickname: replyNickname)
        }

        return result
    }
    
}
