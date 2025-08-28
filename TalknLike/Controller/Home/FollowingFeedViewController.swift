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
        setupUI()
        bindFollowings()
    }
    
    private func setupUI() {
        navigationItem.title = "TalknLike"
        emptyStateMessage = "친구들을 팔로우하여 그들이 올린 게시글을 만나보세요!"
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
