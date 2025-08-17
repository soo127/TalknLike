//
//  CommentViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/14/25.
//

import UIKit
import Combine

final class CommentViewController: UIViewController {
    
    private let commentView = CommentView()
    private var displayComments: [CommentDisplayModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = commentView
        view.backgroundColor = .systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        bindComments()
    }
    
    private func setupTableView() {
        commentView.tableView.dataSource = self
        commentView.tableView.delegate = self
        commentView.tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
    }

    @objc private func didTapClose() {
        dismiss(animated: true)
    }
    
    private func bindComments() {
        CommentManager.shared.commentsPublisher
            .receive(on: RunLoop.main)
            .sink{ [weak self] comments in
                Task {
                    self?.displayComments = try await CommentManager.shared.mergeWithProfiles(comments: comments)
                    self?.commentView.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
}

extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }
        let displayComment = displayComments[indexPath.row]
        let comment = displayComment.comment, profile = displayComment.profile
        
        cell.configure(comment: comment, profile: profile)
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
