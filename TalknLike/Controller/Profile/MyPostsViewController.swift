//
//  MyPostsViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/31/25.
//

import UIKit
import FirebaseFirestore
import Combine
import FirebaseAuth

final class MyPostsViewController: BaseFeedViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "내 게시글"
        bindPosts()
        setupLongPressGesture()
    }
    
    private func bindPosts() {
        PostStore.shared.postsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] posts in
                guard let currentUser = CurrentUserStore.shared.currentUser else {
                    return
                }
                let feedItems = posts.map { post in
                    FeedItem(post: post, profile: currentUser)
                }
                self?.posts = feedItems
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        tableView.addGestureRecognizer(longPressGesture)
    }
    
}

extension MyPostsViewController {
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let point = gesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        
        let post = posts[indexPath.row].post
        showEditDeleteActionSheet(for: post, at: indexPath)
    }
    
    private func showEditDeleteActionSheet(for post: Post, at indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "수정", style: .default) { [weak self] _ in
            self?.editPost(post)
        }
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.confirmDeletePost(post)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func editPost(_ post: Post) {
        let nav = UINavigationController(rootViewController: PostViewController(mode: .edit(post)))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    private func confirmDeletePost(_ post: Post) {
        guard let documentID = post.documentID else { return }
        
        let alert = UIAlertController(
            title: "삭제",
            message: "정말 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "확인", style: .destructive) { [weak self] _ in
            Task {
                try await PostStore.shared.deletePost(documentID: documentID)
                self?.showToast(message: "게시글을 삭제했어요.")
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
}
