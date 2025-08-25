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
        followView.tableView.register(UserListCell.self, forCellReuseIdentifier: "UserListCell")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as? UserListCell else {
            return UITableViewCell()
        }
        let user = followView.selectedTab == 0 ? followers[indexPath.row] : followings[indexPath.row]
        cell.configure(user: user, showAcceptButton: false)
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
