//
//  ProfileViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/21/25.
//

import UIKit
import FirebaseAuth
import Combine

final class ProfileViewController: UIViewController {

    private let profileView = ProfileView()
    private let menuItems: [(String, UIImage?)] = [
        ("내가 쓴 글", UIImage(systemName: "doc.text")),
        ("편집", UIImage(systemName: "pencil")),
        ("로그아웃", UIImage(systemName: "rectangle.portrait.and.arrow.right")),
    ]
    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuData()
        setupMenuActions()
        bindUser()
    }
    
    private func setupMenuData() {
        profileView.menuView.menuItems = menuItems
    }
    
    private func setupMenuActions() {
        profileView.menuView.onMenuTap = { [weak self] index in
            self?.handleMenuSelection(index: index)
        }
    }
    
    private func handleMenuSelection(index: Int) {
        switch index {
        case 0:
            navigationController?.pushViewController(MyPostsViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(ProfileEditViewController(), animated: true)
        case 2:
            showLogOutAlert()
        default:
            break
        }
    }

    private func bindUser() {
        CurrentUserStore.shared.userPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                self?.profileView.headerView.nicknameLabel.text = user.nickname
                self?.profileView.headerView.introLabel.text = user.bio
                Task { @MainActor [weak self] in
                    self?.profileView.headerView.profileImageView.image = await ImageLoader.loadImage(from: user.photoURL) ?? UIImage(systemName: "person.fill")
                }
            }
            .store(in: &cancellables)
    }
    
    private func showLogOutAlert() {
        let alert = UIAlertController(
            title: "로그아웃",
            message: "로그아웃 하시겠습니까?",
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.logOut()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        present(alert, animated: true)
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                return
            }
            let navController = UINavigationController(rootViewController: LoginViewController())
            sceneDelegate.window?.rootViewController = navController
            sceneDelegate.window?.makeKeyAndVisible()
            reset()
        } catch {
            showToast(message: "로그아웃 실패: \(error.localizedDescription)")
        }
    }
    
    private func reset() {
        CurrentUserStore.shared.reset()
        PostStore.shared.reset()
        FollowManager.shared.reset()
    }
    
}
