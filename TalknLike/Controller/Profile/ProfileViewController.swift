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

    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let header = ProfileHeaderView()
    private let menuItems: [(String, UIImage?)] = [
        ("내가 쓴 글", UIImage(systemName: "doc.text")),
        ("편집", UIImage(systemName: "pencil")),
        ("로그아웃", UIImage(systemName: "rectangle.portrait.and.arrow.right")),
    ]
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHeaderView()
        layoutTableView()
        bindUser()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.tableHeaderView = header
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileMenuCell.self, forCellReuseIdentifier: "ProfileMenuCell")
    }
    
    private func setupHeaderView() {
        tableView.tableHeaderView = header
        let width = view.bounds.width
        let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        let height = header.systemLayoutSizeFitting(targetSize).height
        header.frame = CGRect(x: 0, y: 0, width: width, height: height)
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
                self?.header.nicknameLabel.text = user.nickname
                self?.header.introLabel.text = user.bio
                Task { @MainActor [weak self] in
                    self?.header.profileImageView.image = await ImageLoader.loadImage(from: user.photoURL) ?? UIImage(systemName: "person.fill")
                }
            }
            .store(in: &cancellables)
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMenuCell", for: indexPath) as? ProfileMenuCell else {
            return UITableViewCell()
        }
        let (title, image) = menuItems[indexPath.row]
        cell.configure(title: title, image: image)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(MyPostsViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(ProfileEditViewController(), animated: true)
        default:
            logOut()
        }
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
            reset()
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = LoginViewController()
            }
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

