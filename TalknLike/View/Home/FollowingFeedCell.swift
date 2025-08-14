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
    let likeButton = UIButton()

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
        setupLikeButton()
        setupButtonActions()
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
    
    private func setupLikeButton() {
        likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .selected)
        likeButton.setTitle("좋아요", for: .normal)
        likeButton.setTitleColor(.gray, for: .normal)
        likeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    private func setupButtonActions() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        contentView.addSubview(profileImage)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(likeButton)

        profileImage.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            padding: UIEdgeInsets(top: 12, left: 10, bottom: 0, right: 0),
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
            padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        )
        contentLabel.anchor(
            top: profileImage.bottomAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        )
        likeButton.anchor(
            top: contentLabel.bottomAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            padding: UIEdgeInsets(top: 10, left: 10, bottom: 12, right: 0)
        )
    }
    
}

extension FollowingFeedCell {
    
    @objc private func likeButtonTapped() {
        // 좋아요 상태를 서버에 전송하는 함수 호출
        // UI 업데이트 (좋아요 수 등)
        likeButton.isSelected.toggle()
    }

    func configure(post: Post, nickname: String) {
        profileImage.image = UIImage(systemName: "person.crop.circle")
        nicknameLabel.text = nickname
        dateLabel.text = post.createdAt.formatted()
        contentLabel.text = post.content
    }
    
}
