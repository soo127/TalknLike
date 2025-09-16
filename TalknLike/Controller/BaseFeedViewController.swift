//
//  BaseFeedViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/25/25.
//

import UIKit

class BaseFeedViewController: UIViewController {
    
    let tableView = UITableView()
    var posts: [FeedItem] = [] {
        didSet {
            updateEmptyState()
        }
    }
    var emptyStateMessage: String = "게시글이 없습니다."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FollowingFeedCell.self, forCellReuseIdentifier: "FollowingFeedCell")
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
}

extension BaseFeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "FollowingFeedCell",
            for: indexPath
        ) as? FollowingFeedCell else {
            return UITableViewCell()
        }
        let feedItem = posts[indexPath.row]
        cell.configure(post: feedItem.post, nickname: feedItem.profile.nickname)
        loadAsyncData(cell: cell, feedItem: feedItem, indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    private func loadAsyncData(cell: FollowingFeedCell, feedItem: FeedItem, indexPath: IndexPath) {
        Task { @MainActor in
            let profileImage = await ImageLoader.loadImage(from: feedItem.profile.photoURL)
            var isLiked = false
            if let documentID = feedItem.post.documentID {
                isLiked = try await LikeManager.isLiked(postID: documentID)
            }
            if tableView.indexPath(for: cell) == indexPath {
                cell.setProfileImage(profileImage)
                cell.setLikeState(count: feedItem.post.likeCount, isLiked: isLiked)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension BaseFeedViewController: FollowingFeedCellDelegate  {
    
    func didTapLikeButton(_ cell: FollowingFeedCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        cell.toggleLikeState()
        
        let post = posts[indexPath.row].post
        guard let documentID = post.documentID else {
            return
        }
        
        Task {
            let isLiked = cell.likeButton.isSelected
            await LikeManager.handleLike(
                postID: documentID,
                isLiked: isLiked
            )
            if isLiked {
                await NotificationManager.sendNotification(
                    type: .like,
                    receiverID: post.uid,
                    postID: documentID
                )
            }
        }
    }

    func didTapCommentButton(_ cell: FollowingFeedCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let feedItem = posts[indexPath.row]
        guard let postID = feedItem.post.documentID else {
            return
        }
        Task { @MainActor in
            try await CommentManager.shared.fetchComments(postID: postID)
            presentCommentSheet(uid: feedItem.profile.uid, postID: postID)
        }
    }

    func presentCommentSheet(uid: String, postID: String) {
        let nav = UINavigationController(
            rootViewController: CommentViewController(uid: uid, postID: postID)
        )
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        present(nav, animated: true)
    }
    
}

extension BaseFeedViewController {
    
    private func updateEmptyState() {
        if posts.isEmpty {
            tableView.showEmptyState(message: emptyStateMessage)
        } else {
            tableView.hideEmptyState()
        }
    }
    
}
