//
//  CommentView.swift
//  TalknLike
//
//  Created by 이상수 on 8/14/25.
//

import UIKit

final class CommentView: UIView {

    let tableView = UITableView()
    let commentInputView = CommentInputView()
    private lazy var inputViewBottomConstraint: NSLayoutConstraint = {
        commentInputView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupSubviews()
        setupLayout()
    }
    
    func updateInputViewBottomInset(_ inset: CGFloat) {
        inputViewBottomConstraint.constant = -inset
    }
    
}

extension CommentView {
    
    private func setupSubviews() {
        setupTableView()
        setupCommentInputView()
        setupConstraint()
    }
    
    private func setupTableView() {
        addSubview(tableView)
    }
    
    private func setupCommentInputView() {
        addSubview(commentInputView)
    }

    private func setupConstraint() {
        inputViewBottomConstraint.isActive = true
    }
    
}

extension CommentView {
    
    private func setupLayout() {
        layoutTableView()
        layoutCommentInputView()
    }
    
    private func layoutTableView() {
        tableView.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            bottom: commentInputView.topAnchor,
            trailing: trailingAnchor
        )
    }
    
    private func layoutCommentInputView() {
        commentInputView.anchor(
            leading: leadingAnchor,
            trailing: trailingAnchor,
            height: 40
        )
    }
    
}
