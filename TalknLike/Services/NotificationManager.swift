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
            type: type,
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
        
        return try await Firestore.firestore()
            .collection("Notifications")
            .whereField("receiverID", isEqualTo: receiverID)
            .order(by: "createdAt", descending: true)
            .getDocuments()
            .documents
            .compactMap { document in
                var item = try document.data(as: NotificationItem.self)
                item.documentID = document.documentID
                return item
            }
    }
    
    static func deleteNotification(documentID: String) async throws {
        try await Firestore.firestore()
            .collection("Notifications")
            .document(documentID)
            .delete()
    }
    
}
