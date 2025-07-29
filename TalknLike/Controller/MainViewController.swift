//
//  MainViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/21/25.
//

import UIKit

final class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
        let feedVC = UINavigationController(rootViewController: SignUpViewController())
        feedVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)

        let uploadVC = UINavigationController(rootViewController: PostViewController())
        uploadVC.tabBarItem = UITabBarItem(title: "게시", image: UIImage(systemName: "plus.square"), tag: 1)

        let friendsVC = UINavigationController(rootViewController: SignUpViewController())
        friendsVC.tabBarItem = UITabBarItem(title: "친구", image: UIImage(systemName: "person.2"), tag: 2)

        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "프로필", image: UIImage(systemName: "person.crop.circle"), tag: 3)

        viewControllers = [feedVC, uploadVC, friendsVC, profileVC]
    }
    
}
