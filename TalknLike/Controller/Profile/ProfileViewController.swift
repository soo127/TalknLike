//
//  ProfileViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/21/25.
//

import UIKit
import Combine

final class ProfileViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let header = ProfileHeaderView()
    private let menuItems: [(String, UIImage?)] = [
        ("내 프로필", UIImage(systemName: "person")),
        ("내가 쓴 글", UIImage(systemName: "doc.text")),
        ("설정", UIImage(systemName: "gearshape")),
        ("친구 목록", UIImage(systemName: "person.2")),
    ]
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHeaderView()
        layoutTableView()
        setupActions()
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
        print(header.frame)
    }

    private func layoutTableView() {
        tableView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor
        )
    }

    private func setupActions() {
        header.editButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
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
    
    @objc private func editProfile() {
        navigationController?.pushViewController(ProfileEditViewController(), animated: true)
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
        navigationController?.pushViewController(MyPostsViewController(), animated: true)
    }

}

