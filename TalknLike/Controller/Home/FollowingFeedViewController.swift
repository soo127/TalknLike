//
//  FollowingFeedViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/13/25.
//

import UIKit
import Combine

final class FollowingFeedViewController: BaseFeedViewController {
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "TalknLike"
        bindFollowings()
    }

    private func bindFollowings() {
        FollowManager.shared.followingsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] profiles in
                Task {
                    self?.posts = try await PostStore.shared.getFollowingFeed(for: profiles)
                    self?.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
}
