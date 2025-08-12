//
//  MyPostsCell.swift
//  TalknLike
//
//  Created by 이상수 on 7/31/25.
//

import UIKit

final class MyPostsCell: UITableViewCell {

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

extension MyPostsCell {
    
    private func setupProfileImage() {
        profileImage.layer.cornerRadius = 30
        profileImage.clipsToBounds = true
    }
    
    private func setupNicknameLabel() {
        nicknameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }

    private func setupDateLabel() {
        dateLabel.textColor = .gray
    }
    
    private func setupContentLabel() {
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
    }
    
    private func setupLayout() {
        contentView.addSubview(profileImage)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(contentLabel)

        profileImage.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0),
            width: 60,
            height: 60
        )
        nicknameLabel.anchor(
            top: profileImage.topAnchor,
            leading: profileImage.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        )
        dateLabel.anchor(
            top: nicknameLabel.bottomAnchor,
            leading: nicknameLabel.leadingAnchor,
            padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        )
        contentLabel.anchor(
            top: profileImage.bottomAnchor,
            bottom: contentView.bottomAnchor,
            padding: UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        )
    }
    
}

extension MyPostsCell {
    
    func configure(nickname: String, post: Post) {
        profileImage.image = UIImage(systemName: "person.fill")
        nicknameLabel.text = nickname
        contentLabel.text = post.content
        dateLabel.text = post.createdAt.formatted()
    }
    
}
