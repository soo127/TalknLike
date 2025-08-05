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
    private let user = CurrentUserStore.shared.currentUser
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPostsCell", for: indexPath) as? MyPostsCell else {
            return UITableViewCell()
        }
        user
            .handleSome {
                cell.profileImage.image =  ImageLoader.cachedImage(from: $0.photoURL)
                cell.nicknameLabel.text = $0.nickname
                let post = posts[indexPath.row]
                cell.contentLabel.text = post.content
                cell.dateLabel.text = "\(post.createdAt)"
            }
        return cell
    }
    
}

