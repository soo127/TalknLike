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
    }

}

extension MyPostsCell {
    
    private func setupProfileImage() {
        profileImage.layer.cornerRadius = 30
        profileImage.clipsToBounds = true
        
        contentView.addSubview(profileImage)
        profileImage.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0),
            width: 60,
            height: 60,
        )
    }
    
    private func setupNicknameLabel() {
        nicknameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        contentView.addSubview(nicknameLabel)
        nicknameLabel.anchor(
            top: profileImage.topAnchor,
            leading: profileImage.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        )
    }

    private func setupDateLabel() {
        dateLabel.textColor = .gray
        
        contentView.addSubview(dateLabel)
        dateLabel.anchor(
            top: nicknameLabel.bottomAnchor,
            leading: nicknameLabel.leadingAnchor,
            padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        )
    }
    
    private func setupContentLabel() {
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        
        contentView.addSubview(contentLabel)
        contentLabel.anchor(
            top: profileImage.bottomAnchor,
            bottom: contentView.bottomAnchor,
            padding: UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        )
    }
    
}
