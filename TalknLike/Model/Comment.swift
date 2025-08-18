//
//  Comment.swift
//  TalknLike
//
//  Created by 이상수 on 8/15/25.
//

import Foundation

struct Comment: Codable {
    var documentID: String?
    let postID: String
    let uid: String
    let content: String
    let createdAt: Date
    let replyingID: String?
}
