//
//  FollowingFeedCell.swift
//  TalknLike
//
//  Created by 이상수 on 8/13/25.
//

import UIKit

final class FollowingFeedCell: UITableViewCell {

    let profileImage = UIImageView()
    let nicknameLabel = UILabel()
    let dateLabel = UILabel()
    let contentLabel = UILabel()

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
        setupDateLabel()
        setupContentLabel()
        setupLayout()
    }
}

extension FollowingFeedCell {

    private func setupProfileImage() {
        profileImage.layer.cornerRadius = 25
        profileImage.clipsToBounds = true
    }

    private func setupNicknameLabel() {
        nicknameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }

    private func setupDateLabel() {
        dateLabel.textColor = .gray
        dateLabel.font = UIFont.systemFont(ofSize: 12)
    }

    private func setupContentLabel() {
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 14)
    }

    private func setupLayout() {
        contentView.addSubview(profileImage)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(contentLabel)

        profileImage.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            padding: UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 0),
            width: 50,
            height: 50
        )
        nicknameLabel.anchor(
            top: profileImage.topAnchor,
            leading: profileImage.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        )
        dateLabel.anchor(
            top: nicknameLabel.bottomAnchor,
            leading: profileImage.trailingAnchor,
            padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 0)
        )
        contentLabel.anchor(
            top: profileImage.bottomAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        )
    }
    
}
