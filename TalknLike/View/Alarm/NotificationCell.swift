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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(messageLabel)
        profileImageView.image = UIImage(systemName: "person.fill")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 24),
            profileImageView.heightAnchor.constraint(equalToConstant: 24),

            messageLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 15)
    }

    func configure(item: NotificationItem, profile: UserProfile) {
        let nickname = profile.nickname
        switch item.type {
        case .like:
            messageLabel.text = "\(nickname)님이 당신의 게시글을 좋아합니다."
        case .comment:
            messageLabel.text = "\(nickname)님이 당신의 게시글에 댓글을 남겼습니다."
        }
    }
    
}
