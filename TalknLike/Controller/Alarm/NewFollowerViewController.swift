//
//  NewFollowerViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/7/25.
//

import UIKit
import Combine
import FirebaseFirestore

final class NewFollowerViewController: UIViewController {
    
    let newFollowerView = NewFollowerView()
    var followRequests : [UserProfile] = []
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = newFollowerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "새 팔로워"
        setupTableView()
        bindFollowRequests()
    }
    
    private func setupTableView() {
        newFollowerView.tableView.dataSource = self
        newFollowerView.tableView.delegate = self
        newFollowerView.tableView.register(UserListCell.self, forCellReuseIdentifier: "UserListCell")
    }
    
    private func bindFollowRequests() {
        FollowManager.shared.followRequestsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] profiles in
                self?.followRequests = profiles
                self?.newFollowerView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
}

extension NewFollowerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followRequests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as? UserListCell else {
            return UITableViewCell()
        }
        let user = followRequests[indexPath.row]
        cell.configure(user: user, showAcceptButton: true)
        cell.delegate = self
        Task { @MainActor in
            let image = await ImageLoader.loadImage(from: user.photoURL)
            if tableView.indexPath(for: cell) == indexPath {
                cell.profileImage.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension NewFollowerViewController: UserListCellDelegate {
    
    func didTapAccept(_ cell: UserListCell) {
        guard let indexPath = newFollowerView.tableView.indexPath(for: cell) else {
            return
        }
        let user = followRequests[indexPath.row]
        Task {
            try await FollowManager.shared.acceptFollowRequest(for: user)
            showToast(message: "\(user.nickname)님과 친구가 되었어요!")
        }
    }
    
}
