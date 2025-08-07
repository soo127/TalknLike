//
//  SearchUserCell.swift
//  TalknLike
//
//  Created by 이상수 on 8/7/25.
//

import UIKit

final class SearchUserCell: UITableViewCell {
    
    let profileImage = UIImageView()
    let nicknameLabel = UILabel()
    let introLabel = UILabel()
    
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
        setupIntroLabel()
    }
    
}

extension SearchUserCell {
    
    private func setupProfileImage() {
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
        
        contentView.addSubview(profileImage)
        profileImage.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0),
            width: 40,
            height: 40,
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

    private func setupIntroLabel() {
        introLabel.textColor = .gray
        
        contentView.addSubview(introLabel)
        introLabel.anchor(
            top: nicknameLabel.bottomAnchor,
            leading: nicknameLabel.leadingAnchor,
            bottom: contentView.bottomAnchor,
            padding: UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
        )
    }
    
}

extension SearchUserCell {
    
    func configure(user: UserProfile) {
        nicknameLabel.text = user.nickname
        introLabel.text = user.bio
        // 셀 재사용을 위해 이미지 초기화
        profileImage.image = UIImage(systemName: "person.crop.circle")
    }
    
}
