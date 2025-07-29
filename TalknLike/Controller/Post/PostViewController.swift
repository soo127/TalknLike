//
//  PostViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/29/25.
//

import UIKit
import Combine

final class PostViewController: UITabBarController {
    
    private let postView = PostView()
    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        view = postView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUser()
    }
    
    private func bindUser() {
        CurrentUserStore.shared.userPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                self?.postView.nicknameLabel.text = user.nickname
                Task {
                    self?.postView.profileImageView.image = try? await ImageLoader.loadImage(from: user.photoURL) ?? UIImage(systemName: "person.circle")
                }
            }
            .store(in: &cancellables)
    }
    
}
