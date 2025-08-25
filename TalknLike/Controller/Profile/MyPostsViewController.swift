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

final class MyPostsViewController: UIViewController {
    
    private let myPostsView = MyPostsView()
    private var posts: [Post] = []
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = myPostsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "내 게시글"
        setupTableView()
        bindPosts()
    }
    
    private func setupTableView() {
        myPostsView.tableView.dataSource = self
        myPostsView.tableView.delegate = self
        myPostsView.tableView.register(MyPostsCell.self, forCellReuseIdentifier: "MyPostsCell")
    }
    
    private func bindPosts() {
        PostStore.shared.postsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] posts in
                self?.posts = posts
                self?.myPostsView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

}

extension MyPostsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPostsCell", for: indexPath) as? MyPostsCell,
              let user = CurrentUserStore.shared.currentUser else {
            return UITableViewCell()
        }
        let post = posts[indexPath.row]
        cell.configure(title: post.title, nickname: user.nickname, post: post)
        cell.delegate = self
        Task { @MainActor in
            cell.profileImage.image = await ImageLoader.loadImage(from: user.photoURL)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension MyPostsViewController: MyPostsCellDelegate {
    
    func didTapEdit(_ cell: MyPostsCell) {
        guard let indexPath = myPostsView.tableView.indexPath(for: cell) else {
            return
        }
        let post = posts[indexPath.row]
        let nav = UINavigationController(rootViewController: PostViewController(mode: .edit(post)))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func didTapRemove(_ cell: MyPostsCell) {
        guard let indexPath = myPostsView.tableView.indexPath(for: cell),
              let documentID = posts[indexPath.row].documentID else {
            return
        }
        let alert = UIAlertController(
            title: "삭제",
            message: "정말 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
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

