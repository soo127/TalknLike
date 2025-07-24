//
//  UserProfile.swift
//  TalknLike
//
//  Created by 이상수 on 7/24/25.
//

struct UserProfile: Decodable {
    let uid: String
    var nickname: String
    var bio: String
    var photoURL: String
}

extension UserProfile {
    func asDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "nickname": nickname,
            "bio": bio,
            "photoURL": photoURL
        ]
    }
}
