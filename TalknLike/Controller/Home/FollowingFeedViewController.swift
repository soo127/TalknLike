//
//  FollowingFeedViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/13/25.
//

import UIKit
import Combine

final class FollowingFeedViewController: UIViewController {
    
    private let followingFeedView = FollowingFeedView()
    private var followingPosts: [FeedItem] = []
    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        view = followingFeedView
        title = "TalknLike"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindFollowings()
    }
    
    private func setupTableView() {
        followingFeedView.tableView.dataSource = self
        followingFeedView.tableView.delegate = self
        followingFeedView.tableView.register(FollowingFeedCell.self, forCellReuseIdentifier: "FollowingFeedCell")
    }
    
    private func bindFollowings() {
        FollowManager.shared.followingsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] profiles in
                Task {
                    self?.followingPosts = try await PostStore.shared.getFollowingFeed(for: profiles)
                    self?.followingFeedView.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
}

extension FollowingFeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FollowingFeedCell", for: indexPath) as? FollowingFeedCell else {
            return UITableViewCell()
        }
        let post = followingPosts[indexPath.row].post
        let profile = followingPosts[indexPath.row].profile
        cell.configure(post: post, nickname: profile.nickname)
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
    
}

extension FollowingFeedViewController: FollowingFeedCellDelegate {
    
    func didTapLikeButton(_ cell: FollowingFeedCell) {
        guard let indexPath = followingFeedView.tableView.indexPath(for: cell) else {
            return
        }
        let post = followingPosts[indexPath.row].post
        guard let documentID = post.documentID else {
            return
        }
        Task {
            do {
                try await FirestoreService.handleLike(postID: documentID, userID: post.uid, isLiked: cell.likeButton.isSelected)
            } catch {
                print("error z \(error)")
            }
        }
    }
    
}
