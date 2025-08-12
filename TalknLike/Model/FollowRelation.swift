//
//  FollowRelation.swift
//  TalknLike
//
//  Created by 이상수 on 8/12/25.
//

import Foundation

struct FollowRelation: Codable {
    let uid: String
    let date: Date
}

extension FollowRelation {
    static func make(uid: String) -> [String: Any] {
        return [
            "uid": uid,
            "date": Date()
        ]
    }
}
