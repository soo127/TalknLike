//
//  ProfileViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/21/25.
//

import UIKit
import Combine

final class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let profileView = ProfileView()
    private let menuItems: [(String, UIImage?)] = [
        ("내 프로필", UIImage(systemName: "person")),
        ("내가 쓴 글", UIImage(systemName: "doc.text")),
        ("설정", UIImage(systemName: "gearshape")),
        ("친구 목록", UIImage(systemName: "person.2")),
    ]
    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.tableView.delegate = self
        profileView.tableView.dataSource = self
        
        CurrentUserStore.shared.userPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                self?.profileView.nicknameLabel.text = user.nickname
                self?.profileView.introLabel.text = user.bio
                self?.profileView.profileImageView.image = UIImage(systemName: user.photoURL)
            }
            .store(in: &cancellables)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
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
        // TODO: 이동 처리
    }
    
}

