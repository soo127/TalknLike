//
//  NotificationPostViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/25/25.
//

import UIKit

final class NotificationPostViewController: BaseFeedViewController {
    
    private let postID: String

    init(postID: String) {
        self.postID = postID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Task { @MainActor in
            let post = try await FirestoreService.fetchFeedItem(postID: postID)
            self.posts = [post]
            
            self.tableView.reloadData()
        }
    }
    
}

