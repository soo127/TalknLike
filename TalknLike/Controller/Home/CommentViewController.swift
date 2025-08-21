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
    private var replyToCommentID: String? = nil
    private var parentCommentID: String? = nil
    let postID: String
    
    init(postID: String) {
        self.postID = postID
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
        setupCommentInputView()
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
                    let count = comments.count
                    let orderedComments = CommentManager.shared.makeDisplayOrder(comments: comments)
                    self?.displayComments = try await CommentManager.shared.mergeWithProfiles(comments: orderedComments)
                    self?.title = "댓글 \(count)개"
                    self?.commentView.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupCommentInputView() {
        commentView.commentInputView.delegate = self
        CurrentUserStore.shared.currentUser
            .handleSome {
                commentView.commentInputView.configure(profileImageURL: $0.photoURL)
            }
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
    
    func didTapMenu(_ cell: CommentCell) {
        guard let indexPath = commentView.tableView.indexPath(for: cell) else {
            return
        }
        let comment = displayComments[indexPath.row].comment
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "답글", style: .default) { [weak self] _ in
            self?.didTapReply(cell)
        })
        if CommentManager.shared.isMyComment(uid: comment.uid) {
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
                self?.didTapDelete(comment: comment)
            })
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func didTapDelete(comment: Comment) {
        let confirm = UIAlertController(
            title: "삭제",
            message: deleteMessage(parentID: comment.parentID),
            preferredStyle: .alert
        )
        confirm.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
            Task {
                try await CommentManager.shared.deleteComment(comment: comment)
            }
        })
        confirm.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(confirm, animated: true)
    }

    private func deleteMessage(parentID: String?) -> String {
        guard parentID != nil else {
            return "댓글을 삭제할까요? 연결된 답글까지 모두 삭제됩니다."
        }
        return "답글을 삭제할까요?"
    }
    
}

