//
//  ProfileHeaderView.swift
//  TalknLike
//
//  Created by 이상수 on 8/21/25.
//

import UIKit

final class ProfileHeaderView: UIView {

    let editButton = UIButton(type: .system)
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let introLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupSubviews()
        setupLayout()
    }
    
}

extension ProfileHeaderView {
    
    private func setupSubviews() {
        setupProfileImageView()
        setupNicknameLabel()
        setupEditButton()
        setupIntroLabel()
        
        [profileImageView, nicknameLabel, editButton, introLabel].forEach { $0.debugBorder() }
    }
    
    private func setupProfileImageView() {
        addSubview(profileImageView)
        profileImageView.backgroundColor = .lightGray
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
    }
    
    private func setupNicknameLabel() {
        addSubview(nicknameLabel)
        nicknameLabel.font = .boldSystemFont(ofSize: 20)
        nicknameLabel.text = "닉네임"
        nicknameLabel.lineBreakMode = .byTruncatingTail
    }
    
    private func setupEditButton() {
        addSubview(editButton)
        editButton.setTitle("편집", for: .normal)
        editButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupIntroLabel() {
        addSubview(introLabel)
        introLabel.font = .systemFont(ofSize: 14)
        introLabel.textColor = .secondaryLabel
        introLabel.text = "자기소개를 해보세요."
        introLabel.numberOfLines = 0
    }
    
}

extension ProfileHeaderView {
    
    private func setupLayout() {
        layoutProfileImageView()
        layoutNicknameLabel()
        layoutEditButton()
        layoutIntroLabel()
    }
    
    private func layoutProfileImageView() {
        profileImageView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: Paddings.bottom, right: 0),
            width: Sizes.profileImage.width,
            height: Sizes.profileImage.height,
        )
    }
    
    private func layoutNicknameLabel() {
        nicknameLabel.anchor(
            top: topAnchor,
            leading: profileImageView.trailingAnchor,
            trailing: editButton.leadingAnchor,
            padding: UIEdgeInsets(top: 0, left: Paddings.left, bottom: 0, right: 0),
        )
    }
    
    private func layoutEditButton() {
        editButton.anchor(
            top: topAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            width: 35
        )
    }

    private func layoutIntroLabel() {
        introLabel.anchor(
            top: nicknameLabel.bottomAnchor,
            leading: profileImageView.trailingAnchor,
            bottom: bottomAnchor,
            trailing: editButton.leadingAnchor,
            padding: UIEdgeInsets(top: 10, left: Paddings.left, bottom: Paddings.bottom, right: 0),
        )
    }
    
}

extension ProfileHeaderView {
    
    fileprivate enum Sizes {
        static let profileImage = CGSize(width: 80, height: 80)
    }
    
    fileprivate enum Paddings {
        static let top = 16.0
        static let left = 16.0
        static let right = 16.0
        static let bottom = 16.0
    }

}
