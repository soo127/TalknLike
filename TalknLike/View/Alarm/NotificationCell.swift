//
//  NotificationCell.swift
//  TalknLike
//
//  Created by 이상수 on 8/24/25.
//

import UIKit

final class NotificationCell: UITableViewCell {

    private let iconView = UIImageView()
    private let messageLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupViews() {
        contentView.addSubview(iconView)
        contentView.addSubview(messageLabel)
        iconView.image = UIImage(systemName: "heart.fill")
        iconView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),

            messageLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 15)
    }

    func configure(with item: NotificationItem) {
        let nickname = item.senderNickname
        switch item.type {
        case .like:
            messageLabel.text = "\(nickname)님이 당신의 게시글을 좋아합니다."
        case .comment:
            messageLabel.text = "\(nickname)님이 당신의 게시글에 댓글을 남겼습니다."
        case .followPost:
            messageLabel.text = "\(nickname)님이 새 글을 올렸습니다."
        }
    }
    
}
