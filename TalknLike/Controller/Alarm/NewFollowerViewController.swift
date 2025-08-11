//
//  NewFollowerViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/7/25.
//

import UIKit
import Combine

final class NewFollowerViewController: UIViewController {
    
    let newFollowerView = NewFollowerView()
    var followRequests : [UserProfile] = []
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = newFollowerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindFollowRequests()
    }
    
    private func setupTableView() {
        newFollowerView.tableView.dataSource = self
        newFollowerView.tableView.delegate = self
        newFollowerView.tableView.register(FollowRequestCell.self, forCellReuseIdentifier: "FollowRequestCell")
    }
    
    private func bindFollowRequests() {
        FollowManager.shared
            .followRequestsPublisher
            .receive(on: DispatchQueue.main)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FollowRequestCell", for: indexPath) as? FollowRequestCell else {
            return UITableViewCell()
        }
        let user = followRequests[indexPath.row]
        cell.configure(user: user)
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
