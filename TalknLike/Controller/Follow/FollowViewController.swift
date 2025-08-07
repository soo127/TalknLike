//
//  FollowViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/6/25.
//

import UIKit

final class FollowViewController: UIViewController {

    private let followView = FollowView()
    private var followers: [UserProfile] = []
    private var followings: [UserProfile] = []

    override func loadView() {
        view = followView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSegmentHandler()
        loadData()
        setupNavigationBar()
    }

    private func setupTableView() {
        followView.tableView.dataSource = self
        followView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func setupSegmentHandler() {
        followView.segmentChangedHandler = { [weak self] _ in
            self?.followView.tableView.reloadData()
        }
    }

    private func loadData() {
        followers = [
            UserProfile(uid: "1", email: "a@example.com", nickname: "팔로워1", bio: nil, photoURL: nil),
            UserProfile(uid: "2", email: "b@example.com", nickname: "팔로워2", bio: nil, photoURL: nil)
        ]
        followings = [
            UserProfile(uid: "3", email: "c@example.com", nickname: "팔로잉1", bio: nil, photoURL: nil),
            UserProfile(uid: "4", email: "d@example.com", nickname: "팔로잉2", bio: nil, photoURL: nil)
        ]
        followView.tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(didTapPlus)
        )
    }
    
    @objc func didTapPlus() {
        navigationController?.pushViewController(SearchUserViewController(), animated: true)
    }
    
}

extension FollowViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        followView.selectedTab == 0 ? followers.count : followings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = followView.selectedTab == 0 ? followers[indexPath.row] : followings[indexPath.row]
        cell.textLabel?.text = user.nickname
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
