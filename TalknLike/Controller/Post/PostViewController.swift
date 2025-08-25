//
//  PostViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/29/25.
//

import UIKit
import Combine
import FirebaseFirestore

extension PostViewController {
    
    enum Mode {
        case create
        case edit(Post)
    }
    
}

final class PostViewController: UIViewController {
    
    private let mode: Mode
    private let postView = PostView()
    private var cancellables = Set<AnyCancellable>()
    
    init(mode: Mode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = postView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        bindUser()
        setupNavigationBar()
        configureMode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PostViewController {
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
    
    @objc private func didTapPost() {
        Task {
            do {
                try await savePost()
                showAlert(title: "알림", message: toastMessage())
            } catch {
                showAlert(title: "알림", message: "게시 실패")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }

    private func savePost() async throws {
        let title = postView.titleTextField.text
        let content = postView.textView.text
        switch mode {
        case .create:
            try await PostStore.shared.post(title: title, content: content)
        case .edit(let post):
            try await post.documentID
                .handleSome {
                    try await PostStore.shared.updatePost(documentID: $0, newTitle: title, newContent: content)
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
                    self?.postView.profileImageView.image = await ImageLoader.loadImage(from: user.photoURL) ?? UIImage(systemName: "person.fill")
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
    
    private func configureMode() {
        switch mode {
        case .create:
            title = "새 게시글"
        case .edit(let post):
            title = "게시글 수정"
            postView.textView.text = post.content
            postView.titleTextField.text = post.title
            postView.placeholderLabel.isHidden = true
        }
    }
    
    private func toastMessage() -> String {
        switch mode {
        case .create:
            return "게시 성공"
        case .edit:
            return "수정 완료"
        }
    }
    
}
