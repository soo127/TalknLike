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
        delegate = self
        setupTabs()
    }

    private func setupTabs() {
        let feedVC = UINavigationController(rootViewController: FollowingFeedViewController())
        feedVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)

        let friendsVC = UINavigationController(rootViewController: FollowViewController())
        friendsVC.tabBarItem = UITabBarItem(title: "친구", image: UIImage(systemName: "person.2"), tag: 1)
        
        let dummyUploadVC = UIViewController()
        dummyUploadVC.tabBarItem = UITabBarItem(title: "게시", image: UIImage(systemName: "plus.square"), tag: 2)

        let alarmVC = UINavigationController(rootViewController: NewFollowerViewController())
        alarmVC.tabBarItem = UITabBarItem(title: "알림", image: UIImage(systemName: "bell"), tag: 3)

        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "프로필", image: UIImage(systemName: "person.crop.circle"), tag: 4)

        viewControllers = [feedVC, friendsVC, dummyUploadVC, alarmVC, profileVC]
    }
    
}

extension MainViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            let nav = UINavigationController(rootViewController: PostViewController(mode: .create))
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
            return false
        }
        return true
    }
    
}
