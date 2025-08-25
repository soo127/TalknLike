//
//  BaseFeedViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/25/25.
//

import UIKit

class BaseFeedViewController: UIViewController {
    
    var posts: [FeedItem] = []
    let tableView = UITableView()
    
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
        cell.delegate = self
        
        Task { @MainActor in
            if tableView.indexPath(for: cell) == indexPath {
                cell.profileImage.image = await ImageLoader.loadImage(from: feedItem.profile.photoURL)
                if let documentID = feedItem.post.documentID {
                    cell.likeButton.isSelected = try await LikeManager.isLiked(
                        postID: documentID,
                        userID: feedItem.post.uid
                    )
                }
            }
        }
        return cell
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
        let post = posts[indexPath.row].post
        guard let documentID = post.documentID else {
            return
        }

        Task {
            await LikeManager.handleLike(
                postID: documentID,
                userID: post.uid,
                isLiked: cell.likeButton.isSelected
            )
            await NotificationManager.sendNotification(
                type: .like,
                receiverID: post.uid,
                postID: documentID
            )
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
