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
    private var replyToCommentID: String?
    private var parentCommentID: String?
    let postID: String
    
    init(postID: String) {
        self.postID = postID
        parentCommentID = nil
        replyToCommentID = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = commentView
        view.backgroundColor = .systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        bindComments()
        commentView.commentInputView.delegate = self
        setupKeyboardObservers()
        setupDismissKeyboardGesture()
    }
    
    private func setupTableView() {
        commentView.tableView.dataSource = self
        commentView.tableView.delegate = self
        commentView.tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        commentView.tableView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
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
                    let orderedComments = CommentManager.shared.makeDisplayOrder(comments: comments)
                    self?.displayComments = try await CommentManager.shared.mergeWithProfiles(comments: orderedComments)
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
        cell.configure(
            comment: displayComment.comment,
            nickname: displayComment.profile.nickname,
            replyTo: displayComment.replyNickname
        )
        cell.delegate = self
        Task { @MainActor in
            let image = await ImageLoader.loadImage(from: displayComment.profile.photoURL)
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

extension CommentViewController {
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        UIView.animate(withDuration: duration) {
            self.commentView.updateInputViewBottomInset(keyboardFrame.height)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        UIView.animate(withDuration: duration) {
            self.commentView.updateInputViewBottomInset(0)
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard(_ gesture: UITapGestureRecognizer) {
        if commentView.commentInputView.isClicked {
            commentView.commentInputView.clearReply()
            resetReplyState()
            view.endEditing(true)
            return
        }
        // 키보드가 없을 때는 여기에 다른 터치 로직 실행
        // 예: 테이블 뷰 셀 선택 처리
    }
    
}

extension CommentViewController: CommentInputViewDelegate {
    
    func commentInputView(didSubmit text: String?) {
        guard let text, !text.isEmpty else {
            return
        }
        Task {
            try await CommentManager.shared.addComment(
                postID: postID,
                content: text,
                parentID: parentCommentID,
                replyTo: replyToCommentID
            )
            commentView.commentInputView.clearText()
            commentView.commentInputView.clearReply()
            resetReplyState()
            commentView.endEditing(true)
        }
    }
    
    func resetReplyState() {
        parentCommentID = nil
        replyToCommentID = nil
    }
    
}

extension CommentViewController: CommentCellDelegate {
    
    func didTapReply(_ cell: CommentCell) {
        guard let indexPath = commentView.tableView.indexPath(for: cell) else {
            return
        }
        let displayComment = displayComments[indexPath.row]
        let parentID = displayComment.comment.parentID
        let documentID = displayComment.comment.documentID
        
        parentCommentID = parentID ?? documentID
        replyToCommentID = documentID
        let nickname = displayComment.profile.nickname
        
        commentView.commentInputView.setupReply(nickname: nickname, commentID: replyToCommentID)
    }
    
}

