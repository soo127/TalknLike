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
    var followRelations : [FollowRequest] = []
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
        newFollowerView.tableView.register(FollowRequestCell.self, forCellReuseIdentifier: "FollowRequestCell")
    }
    
    private func bindFollowRequests() {
        FollowManager.shared.followRequestsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] followRelations in
                self?.followRelations = followRelations
                self?.newFollowerView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
}

extension NewFollowerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followRelations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FollowRequestCell", for: indexPath) as? FollowRequestCell else {
            return UITableViewCell()
        }
        let profile = followRelations[indexPath.row].profile
        let date = followRelations[indexPath.row].date

        cell.configure(user: profile, date: date, showAcceptButton: true)
        cell.delegate = self
        Task { @MainActor in
            let image = await ImageLoader.loadImage(from: profile.photoURL)
            if tableView.indexPath(for: cell) == indexPath {
                cell.profileImage.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let rejectAction = UIContextualAction(style: .destructive, title: "거절") { [weak self] (action, view, completion) in
            self?.rejectFollowRequest(at: indexPath)
        }
        rejectAction.backgroundColor = .systemRed
        rejectAction.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [rejectAction])
        return configuration
    }
    
    private func rejectFollowRequest(at indexPath: IndexPath) {
        let user = followRelations[indexPath.row].profile
        Task { @MainActor in
            try await FollowManager.shared.rejectFollowRequest(for: user)
        }
    }
    
}

extension NewFollowerViewController: FollowRequestCellDelegate {
    
    func didTapAccept(_ cell: FollowRequestCell) {
        guard let indexPath = newFollowerView.tableView.indexPath(for: cell) else {
            return
        }
        let user = followRelations[indexPath.row].profile
        Task {
            try await FollowManager.shared.acceptFollowRequest(for: user)
            showToast(message: "\(user.nickname)님과 친구가 되었어요!")
        }
    }
    
}
