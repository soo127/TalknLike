//
//  UserPostsViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/28/25.
//

import UIKit

final class UserPostsViewController: BaseFeedViewController {
    
    private let userProfile: UserProfile
    
    init(userProfile: UserProfile) {
        self.userProfile = userProfile
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(userProfile.nickname)"
        loadFeedItems()
    }
    
    private func loadFeedItems() {
        Task { @MainActor in
            self.posts = try await FirestoreService.fetchFeedItems(uid: userProfile.uid)
            self.tableView.reloadData()
        }
    }
    
}
