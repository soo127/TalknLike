//
//  Post.swift
//  TalknLike
//
//  Created by 이상수 on 7/31/25.
//

import Foundation

struct Post: Codable {
    var documentID: String?
    let uid: String
    let content: String
    let createdAt: Date
    let likeCount: Int
}
