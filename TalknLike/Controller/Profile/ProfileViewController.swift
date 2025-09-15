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

    private let headerView = ProfileHeaderView()
    private let tableView = UITableView()
    private let menuItems = ProfileMenuConfig.items
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        layoutTableView()
        bindUser()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileMenuCell.self, forCellReuseIdentifier: "ProfileMenuCell")
    }
    
    private func layoutTableView() {
        tableView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor
        )
    }

    private func bindUser() {
        CurrentUserStore.shared.userPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                self?.setupHeader(user: user)
            }
            .store(in: &cancellables)
    }
    
    private func setupHeader(user: UserProfile) {
        headerView.nicknameLabel.text = user.nickname
        headerView.introLabel.text = user.bio
        Task { @MainActor [weak self] in
            self?.headerView.profileImageView.image = await ImageLoader.loadImage(from: user.photoURL) ?? UIImage(systemName: "person.fill")
        }
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

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMenuCell", for: indexPath) as? ProfileMenuCell else {
            return UITableViewCell()
        }
        let item = menuItems[indexPath.row]
        cell.configure(title: item.title, image: item.icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
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
    
}
    
