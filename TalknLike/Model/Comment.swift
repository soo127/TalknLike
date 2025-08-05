//
//  Comment.swift
//  TalknLike
//
//  Created by 이상수 on 8/5/25.
//

import Foundation

struct Comment: Decodable {
    let uid: String
    let postId: String
    let content: String
    let createdAt: Date
}
