//
//  ProfileEditItem.swift
//  TalknLike
//
//  Created by 이상수 on 7/28/25.
//

import UIKit

enum ProfileEditItem: CaseIterable {
    case nickname
    case bio

    var title: String {
        switch self {
        case .nickname: return "닉네임"
        case .bio: return "자기소개"
        }
    }

    func destinationViewController() -> UIViewController {
        switch self {
        case .nickname: return NicknameViewController()
        case .bio: return SelfIntroductionViewController()
        }
    }
}
