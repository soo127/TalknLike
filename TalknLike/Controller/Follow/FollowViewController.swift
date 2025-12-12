//
//  FollowViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/6/25.
//

import UIKit
import Combine

final class FollowViewController: UIViewController {

    private let followView = FollowView()
    private var followers: [UserProfile] = []
    private var followings: [UserProfile] = []
    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        view = followView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        bindFollowData()
        followView.delegate = self
    }

    private func setupTableView() {
        followView.tableView.dataSource = self
        followView.tableView.delegate = self
        followView.tableView.register(SearchUserCell.self, forCellReuseIdentifier: SearchUserCell.identifier)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(didTapSearch)
        )
    }
    
    private func bindFollowData() {
        FollowManager.shared.followersPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] profiles in
                self?.followers = profiles
                self?.followView.updateFollowerCount(profiles.count)
                self?.followView.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        FollowManager.shared.followingsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] profiles in
                self?.followings = profiles
                self?.followView.updateFollowingCount(profiles.count)
                self?.followView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc private func didTapSearch() {
        navigationController?.pushViewController(SearchUserViewController(), animated: true)
    }
    
}

extension FollowViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchUserCell.identifier,
            for: indexPath
        ) as? SearchUserCell else {
            return UITableViewCell()
        }
        let user = currentUsers[indexPath.row]
        configureCell(cell, user: user, at: indexPath)
        return cell
    }
    
    func configureCell(_ cell: SearchUserCell, user: UserProfile, at indexPath: IndexPath) {
        cell.delegate = self
        
        switch followView.selectedTab {
        case .followers:
            cell.configureFollower(user: user)
        case .followings:
            cell.configureFollowing(user: user)
        }
    }
    
}

extension FollowViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let profile = currentUsers[indexPath.row]
        let userPostsVC = UserPostsViewController(userProfile: profile)
        navigationController?.pushViewController(userPostsVC, animated: true)
    }
    
}

extension FollowViewController: SearchUserCellDelegate {
    
    func didTapButton(_ cell: SearchUserCell) {
        guard followView.selectedTab == .followings else {
            return
        }
        guard let indexPath = followView.tableView.indexPath(for: cell) else {
            return
        }
        let following = followings[indexPath.row]
        showUnfollowAlert(for: following)
    }
    
}

extension FollowViewController: FollowViewDelegate {
    
    func didSelectSegment(at index: Int) {
        followView.tableView.reloadData()
    }
    
}

extension FollowViewController {
    
    var currentUsers: [UserProfile] {
        return followView.selectedTab == .followers ? followers : followings
    }
    
    func showUnfollowAlert(for user: UserProfile) {
        let alert = UIAlertController(
            title: "팔로우 취소",
            message: "\(user.nickname)님을 언팔로우하시겠습니까?",
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.unfollowUser(user)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        present(alert, animated: true)
    }
    
    func unfollowUser(_ user: UserProfile) {
        Task {
            do {
                try await FollowManager.shared.unfollow(uid: user.uid)
                showToast(message: "더 이상 \(user.nickname)님을 팔로우하지 않습니다.")
            } catch {
                showToast(message: "언팔로우에 실패했습니다.")
            }
        }
    }
    
}
