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

        let searchVC = UINavigationController(rootViewController: SignUpViewController())
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 1)

        let uploadVC = UINavigationController(rootViewController: SignUpViewController())
        uploadVC.tabBarItem = UITabBarItem(title: "업로드", image: UIImage(systemName: "plus.square"), tag: 2)

        let friendsVC = UINavigationController(rootViewController: SignUpViewController())
        friendsVC.tabBarItem = UITabBarItem(title: "친구", image: UIImage(systemName: "person.2"), tag: 3)

        let profileVC = UINavigationController(rootViewController: SignUpViewController())
        profileVC.tabBarItem = UITabBarItem(title: "프로필", image: UIImage(systemName: "person.crop.circle"), tag: 4)

        viewControllers = [feedVC, searchVC, uploadVC, friendsVC, profileVC]
    }
    
}
