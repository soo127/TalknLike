//
//  FollowMetadata.swift
//  TalknLike
//
//  Created by 이상수 on 8/12/25.
//

import Foundation

struct FollowMetadata: Codable {
    let uid: String
    let date: Date
}

extension FollowMetadata {
    static func make(uid: String) -> [String: Any] {
        return [
            "uid": uid,
            "date": Date()
        ]
    }
}
