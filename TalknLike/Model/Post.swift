//
//  Post.swift
//  TalknLike
//
//  Created by 이상수 on 7/31/25.
//

import Foundation

struct Post: Decodable {
    let profile: UserProfile
    let content: String
    let createdAt: Date
}
