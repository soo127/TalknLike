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
        cell.configure(nickname: user.nickname, post: post)
        Task { @MainActor in
            cell.profileImage.image = await ImageLoader.loadImage(from: user.photoURL)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

