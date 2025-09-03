//
//  UserProfile.swift
//  TalknLike
//
//  Created by 이상수 on 7/24/25.
//

struct UserProfile: Codable {
    let uid: String
    let email: String
    var nickname: String
    var bio: String?
    var photoURL: String?
}

extension UserProfile {
    static func initial(uid: String, email: String) -> UserProfile {
        return UserProfile(
            uid: uid,
            email: email,
            nickname: "닉네임",
            bio: nil,
            photoURL: nil
        )
    }
}
