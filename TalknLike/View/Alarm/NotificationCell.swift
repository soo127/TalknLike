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
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(dateLabel)
        profileImageView.image = UIImage(systemName: "person.fill")
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .gray
        dateLabel.font = .systemFont(ofSize: 14)
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),

            messageLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            dateLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 12),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 15)
    }

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
