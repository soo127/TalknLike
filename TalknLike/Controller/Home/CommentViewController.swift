//
//  CommentViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/14/25.
//

import UIKit

final class CommentViewController: UIViewController {
    
    private let commentView = CommentView()
    
    override func loadView() {
        view = commentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        commentView.tableView.dataSource = self
        commentView.tableView.delegate = self
        commentView.tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
    }
    
}

extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }
        cell.commentLabel.text = "Hello, World!"
        cell.profileImage.image = UIImage(systemName: "person.circle")
        cell.dateLabel.text = "2025-08-14"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
