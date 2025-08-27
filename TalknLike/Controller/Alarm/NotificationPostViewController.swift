//
//  NotificationPostViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/25/25.
//

import UIKit
import FirebaseFirestore

final class NotificationPostViewController: BaseFeedViewController {
    
    private let postID: String
    private var listener: ListenerRegistration?
    
    init(postID: String) {
        self.postID = postID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observePost()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
        listener = nil
    }
    
    private func loadPost() {
        Task { @MainActor in
            do {
                let post = try await FirestoreService.fetchFeedItem(postID: postID)
                self.posts = [post]
                self.tableView.reloadData()
            } catch {
                self.showDeletedAlert()
            }
        }
    }
    
    deinit {
        listener?.remove()
        listener = nil
    }
    
}

extension NotificationPostViewController {
    
    private func observePost() {
        listener = Firestore.firestore()
            .collection("Posts")
            .document(postID)
            .addSnapshotListener { [weak self] snapshot, _ in
                if snapshot?.exists == false {
                    self?.showDeletedAlert()
                }
            }
    }
    
    private func showDeletedAlert() {
        let alert = UIAlertController(
            title: "게시글 삭제됨",
            message: "이 게시글은 삭제되었습니다.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
}
