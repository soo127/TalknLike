//
//  NotificationManager.swift
//  TalknLike
//
//  Created by 이상수 on 8/24/25.
//

import FirebaseFirestore

enum NotificationManager {
    
    static func sendLikeNotification(
        receiverID: String,
        nickname: String,
        senderID: String,
        postID: String,
    ) async {
        let noti = NotificationItem(
            type: .like,
            senderID: senderID,
            senderNickname: nickname,
            receiverID: receiverID,
            postID: postID,
            createdAt: Date()
        )

        try? Firestore.firestore()
            .collection("Notifications")
            .document()
            .setData(from: noti)
    }
    
    static func fetchNotifications(receiverID: String) async throws -> [NotificationItem] {
        let snapshot = try await Firestore.firestore()
            .collection("Notifications")
            .whereField("receiverID", isEqualTo: receiverID)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        print(snapshot.documents)
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: NotificationItem.self)
        }
    }
    
}
