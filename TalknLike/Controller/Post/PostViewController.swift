//
//  PostViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/29/25.
//

import UIKit
import Combine
import FirebaseFirestore
import Supabase

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
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
    
    @objc private func didTapPost() {
        Task {
            do {
                let content = postView.textView.text ?? ""
                try await PostStore.shared.post(content: content)
                showToast(message: "게시 성공")
                dismiss(animated: true)
            } catch {
                showToast(message: "게시 실패")
            }
        }
    }

}

extension PostViewController {
    
    private func bindUser() {
        CurrentUserStore.shared.userPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                self?.postView.nicknameLabel.text = user.nickname
                Task { @MainActor [weak self] in
                    self?.postView.profileImageView.image = ImageLoader.cachedImage(from: user.photoURL) ?? UIImage(systemName: "person.fill")
                }
            }
            .store(in: &cancellables)
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
    
}
