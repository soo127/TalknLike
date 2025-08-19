//
//  CommentCell.swift
//  TalknLike
//
//  Created by 이상수 on 8/14/25.
//

import UIKit

protocol CommentCellDelegate: AnyObject {
    func didTapReply(_ cell: CommentCell)
}

final class CommentCell: UITableViewCell {
    
    weak var delegate: CommentCellDelegate?
    
    let containerView = UIView()
    let profileImage = UIImageView()
    let nicknameLabel = UILabel()
    let commentLabel = UILabel()
    let dateLabel = UILabel()
    let replyButton = UIButton(type: .system)
    
    private lazy var containerLeadingConstraint: NSLayoutConstraint = {
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupProfileImage()
        setupNicknameLabel()
        setupCommentLabel()
        setupDateLabel()
        setupReplyButton()
        setupLayout()
    }
    
}

extension CommentCell {
    
    func setupProfileImage() {
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
    }
    
    func setupNicknameLabel() {
        nicknameLabel.font = .boldSystemFont(ofSize: 14)
        nicknameLabel.textColor = .label
    }
    
    func setupCommentLabel() {
        commentLabel.font = .systemFont(ofSize: 14)
        commentLabel.textColor = .label
        commentLabel.numberOfLines = 0
    }
    
    func setupDateLabel() {
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryLabel
    }
    
    func setupReplyButton() {
        replyButton.setTitle("답글", for: .normal)
        replyButton.titleLabel?.font = .systemFont(ofSize: 12)
        replyButton.addTarget(self, action: #selector(didTapReply), for: .touchUpInside)
    }
    
    @objc private func didTapReply() {
        delegate?.didTapReply(self)
    }
    
    func setupLayout() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(profileImage)
        containerView.addSubview(nicknameLabel)
        containerView.addSubview(commentLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(replyButton)
        
        containerLeadingConstraint.isActive = true
        containerView.anchor(
            top: contentView.topAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 8)
        )
        profileImage.anchor(
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            width: 40,
            height: 40
        )
        nicknameLabel.anchor(
            top: containerView.topAnchor,
            leading: profileImage.trailingAnchor,
            trailing: containerView.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        )
        commentLabel.anchor(
            top: nicknameLabel.bottomAnchor,
            leading: nicknameLabel.leadingAnchor,
            trailing: containerView.trailingAnchor,
            padding: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        )
        dateLabel.anchor(
            top: commentLabel.bottomAnchor,
            leading: nicknameLabel.leadingAnchor,
            bottom: containerView.bottomAnchor,
            padding: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        )
        replyButton.anchor(
            top: commentLabel.bottomAnchor,
            leading: dateLabel.trailingAnchor,
            bottom: containerView.bottomAnchor,
            padding: UIEdgeInsets(top: 4, left: 16, bottom: 0, right: 0)
        )
    }
    
}

extension CommentCell {
    
    func configure(comment: Comment, profile: UserProfile) {
        nicknameLabel.text = profile.nickname
        commentLabel.text = comment.content
        dateLabel.text = comment.createdAt.formatted()
        profileImage.image = UIImage(systemName: "person.circle")
        containerLeadingConstraint.constant = comment.parentID != nil ? 48 : 8
    }
    
}
