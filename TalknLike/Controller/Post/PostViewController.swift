//
//  PostViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/29/25.
//

import UIKit
import Combine

final class PostViewController: UIViewController {
    
    private let postView = PostView()
    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        view = postView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        bindUser()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "게시",
            style: .done,
            target: self,
            action: #selector(didTapPost)
        )
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
    
    @objc private func didTapPost() {
        // 게시 처리 로직
        dismiss(animated: true)
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
