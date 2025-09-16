//
//  NotificationCell.swift
//  TalknLike
//
//  Created by 이상수 on 8/24/25.
//

import UIKit

final class NotificationCell: UITableViewCell {

    let profileImageView = UIImageView()
    private let messageLabel = UILabel()
    private let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        setupSubviews()
        setupLayout()
    }
    
}

extension NotificationCell {
    
    private func setupSubviews() {
        setupProfileImageView()
        setupMessageLabel()
        setupDateLabel()
    }
    
    private func setupProfileImageView() {
        contentView.addSubview(profileImageView)
        profileImageView.image = UIImage(systemName: "person.fill")
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupMessageLabel() {
        contentView.addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 15)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.textColor = .gray
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

extension NotificationCell {
    
    private func setupLayout() {
        layoutProfileImageView()
        layoutMessageLabel()
        layoutDateLabel()
    }
    
    private func layoutProfileImageView() {
        profileImageView.anchor(
            leading: contentView.leadingAnchor,
            padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0),
            width: 50,
            height: 50,
            centerY: contentView.centerYAnchor,
        )
    }
    
    private func layoutMessageLabel() {
        messageLabel.anchor(
            top: contentView.topAnchor,
            leading: profileImageView.trailingAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 16),
        )
    }
    
    private func layoutDateLabel() {
        dateLabel.anchor(
            top: messageLabel.bottomAnchor,
            leading: profileImageView.trailingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 16),
        )
    }
    
}

extension NotificationCell {
    
    func configure(item: NotificationItem, profile: UserProfile) {
        let nickname = profile.nickname
        dateLabel.text = item.createdAt.formatted()
        switch item.type {
        case .like:
            messageLabel.text = "\(nickname)님이 당신의 게시글을 좋아합니다."
        case .comment:
            messageLabel.text = "\(nickname)님이 당신의 게시글에 댓글을 남겼습니다."
        }
    }
    
}
