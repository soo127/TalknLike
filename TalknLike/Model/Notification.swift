//
//  Notification.swift
//  TalknLike
//
//  Created by 이상수 on 8/24/25.
//

import Foundation

enum NotificationType: String, Codable {
    case like
    case comment
    case followPost
}

struct NotificationItem: Codable {
    let type: NotificationType
    let senderID: String
    let senderNickname: String
    let receiverID: String
    let postID: String?
    let createdAt: Date
}

