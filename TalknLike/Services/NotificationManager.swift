//
//  NotificationManager.swift
//  TalknLike
//
//  Created by 이상수 on 8/24/25.
//

import FirebaseFirestore

enum NotificationManager {
    
    static func sendNotification(
        type: NotificationType,
        receiverID: String,
        postID: String
    ) async {
        guard let senderID = CurrentUserStore.shared.currentUser?.uid else {
            return
        }
        let noti = NotificationItem(
            type: .like,
            senderID: senderID,
            receiverID: receiverID,
            postID: postID,
            createdAt: Date()
        )

        try? Firestore.firestore()
            .collection("Notifications")
            .document()
            .setData(from: noti)
    }
    
    static func fetchNotifications() async throws -> [NotificationItem] {
        guard let receiverID = CurrentUserStore.shared.currentUser?.uid else {
            return []
        }
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
