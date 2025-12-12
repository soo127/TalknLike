//
//  SearchUserCell.swift
//  TalknLike
//
//  Created by 이상수 on 8/7/25.
//

import UIKit

protocol SearchUserCellDelegate: AnyObject {
    func didTapButton(_ cell: SearchUserCell)
}

final class SearchUserCell: UITableViewCell {
    
    weak var delegate: SearchUserCellDelegate?
    private let profileImage = UIImageView()
    private let nicknameLabel = UILabel()
    private let introLabel = UILabel()
    private let followButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupSubviews()
        setupLayout()
    }
    
    @objc private func followButtonTapped() {
        delegate?.didTapButton(self)
    }
    
}

extension SearchUserCell {
    
    private func setupSubviews() {
        setupProfileImage()
        setupNicknameLabel()
        setupIntroLabel()
        setupFollowButton()
    }
    
    private func setupProfileImage() {
        contentView.addSubview(profileImage)
        profileImage.image = UIImage(systemName: "person.crop.circle")
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
    }
    
    private func setupNicknameLabel() {
        contentView.addSubview(nicknameLabel)
        nicknameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }

    private func setupIntroLabel() {
        contentView.addSubview(introLabel)
        introLabel.textColor = .gray
    }
    
    private func setupFollowButton() {
        contentView.addSubview(followButton)
    }

}

extension SearchUserCell {
    
    private func setupLayout() {
        layoutProfileImage()
        layoutNicknameLabel()
        layoutIntroLabel()
        layoutFollowButton()
    }
    
    private func layoutProfileImage() {
        profileImage.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0),
            width: 40,
            height: 40,
        )
    }
    
    private func layoutNicknameLabel() {
        nicknameLabel.anchor(
            top: profileImage.topAnchor,
            leading: profileImage.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        )
    }
    
    private func layoutIntroLabel() {
        introLabel.anchor(
            top: nicknameLabel.bottomAnchor,
            leading: nicknameLabel.leadingAnchor,
            bottom: contentView.bottomAnchor,
            padding: UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
        )
    }
    
    private func layoutFollowButton() {
        followButton.anchor(
            trailing: contentView.trailingAnchor,
            centerY: contentView.centerYAnchor
        )
    }
    
}

extension SearchUserCell {
    
    func configureSearch(user: UserProfile, shouldShowFollowButton: Bool) {
        followButton.isHidden = !shouldShowFollowButton
        followButton.configure(
            title: "팔로우",
            backgroundColor: .systemBlue
        )
        configure(user: user)
    }
    
    func configureFollower(user: UserProfile) {
        followButton.isHidden = true
        configure(user: user)
    }
    
    func configureFollowing(user: UserProfile) {
        followButton.isHidden = false
        followButton.configure(
            title: "해제",
            backgroundColor: .systemRed,
        )
        configure(user: user)
    }
    
    private func configure(user: UserProfile) {
        nicknameLabel.text = user.nickname
        introLabel.text = user.bio
        Task { @MainActor in
            let image = await ImageLoader.loadImage(from: user.photoURL)
            profileImage.image = image
        }
    }
    
}
