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
        setupSegmentHandler()
        setupNavigationBar()
        bindFollowData()
    }

    private func setupTableView() {
        followView.tableView.dataSource = self
        followView.tableView.delegate = self
        followView.tableView.register(SearchUserCell.self, forCellReuseIdentifier: "SearchUserCell")
    }

    private func setupSegmentHandler() {
        followView.segmentChangedHandler = { [weak self] _ in
            self?.followView.tableView.reloadData()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(didTapPlus)
        )
    }
    
    private func bindFollowData() {
        FollowManager.shared.followersPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] profiles in
                self?.followers = profiles
                self?.followView.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        FollowManager.shared.followingsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] profiles in
                self?.followings = profiles
                self?.followView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc func didTapPlus() {
        navigationController?.pushViewController(SearchUserViewController(), animated: true)
    }
    
}

extension FollowViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        followView.selectedTab == 0 ? followers.count : followings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserCell", for: indexPath) as? SearchUserCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        let user: UserProfile
        if followView.selectedTab == 0 {
            user = followers[indexPath.row]
            cell.configureFollower(user: followers[indexPath.row])
        } else {
            user = followings[indexPath.row]
            cell.configureFollowing(user: followings[indexPath.row])
        }
        
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

extension FollowViewController: SearchUserCellDelegate {
    
    func didTapButton(_ cell: SearchUserCell) {
//        guard let indexPath = followView.tableView.indexPath(for: cell) else {
//            return
//        }
        if followView.selectedTab == 0 {
            // 팔로워 제거
            print("팔로워 제거")
        } else {
            // 팔로우 취소
            print("팔로우 취소")
        }
    }
    
}
