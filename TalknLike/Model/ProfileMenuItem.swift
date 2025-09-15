//
//  ProfileMenuItem.swift
//  TalknLike
//
//  Created by 이상수 on 9/15/25.
//

import UIKit

struct ProfileMenuItem {
    let title: String
    let icon: UIImage?
}

enum ProfileMenuConfig {
    static let items: [ProfileMenuItem] = [
        ProfileMenuItem(title: "내가 쓴 글", icon: UIImage(systemName: "doc.text")),
        ProfileMenuItem(title: "편집", icon: UIImage(systemName: "pencil")),
        ProfileMenuItem(title: "로그아웃", icon: UIImage(systemName: "rectangle.portrait.and.arrow.right"))
    ]
}
