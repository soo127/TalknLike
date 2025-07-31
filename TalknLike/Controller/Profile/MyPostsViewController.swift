//
//  MyPostsViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/31/25.
//

import UIKit
import FirebaseFirestore

final class MyPostsViewController: UIViewController {
    
    private let myPostsView = MyPostsView()
    private var posts: [Post] = []
    
    override func loadView() {
        view = myPostsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "내 게시글"
        setupTableView()
        loadMyPosts()
    }
    
    private func setupTableView() {
        myPostsView.tableView.dataSource = self
        myPostsView.tableView.delegate = self
    }
    
    private func loadMyPosts() {
        guard let userId = CurrentUserStore.shared.currentUser?.uid else { return }
        
        Task { @MainActor [weak self] in
            do {
                self?.posts = try await self?.fetchMyPosts(userId: userId) ?? []
                self?.myPostsView.tableView.reloadData()
            } catch {
                print("게시글 가져오기 실패:", error)
            }
        }
    }
    
    private func fetchMyPosts(userId: String) async throws -> [Post] {
        let snapshot = try await Firestore.firestore()
            .collection("Posts")
            .whereField("profile.uid", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments()

        return try snapshot.documents.compactMap { document in
            try Firestore.Decoder().decode(Post.self, from: document.data())
        }
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
        
        let post = posts[indexPath.row]
        cell.contentLabel.text = post.content
        cell.profileImage.image = UIImage(systemName: "person")
        cell.dateLabel.text = "\(post.createdAt)"
        cell.nicknameLabel.text = post.profile.nickname
        return cell
    }
    
}

