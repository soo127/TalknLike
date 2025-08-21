//
//  UserListCell.swift
//  TalknLike
//
//  Created by 이상수 on 8/7/25.
//

import UIKit

protocol UserListCellDelegate: AnyObject {
    func didTapAccept(_ cell: UserListCell)
}

final class UserListCell: UITableViewCell {
    
    weak var delegate: UserListCellDelegate?
    let profileImage = UIImageView()
    let nicknameLabel = UILabel()
    let dateLabel = UILabel()
    let acceptButton = UIButton()
    
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
        setupAcceptButton()
        setupLayout()
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }
    
    @objc private func acceptButtonTapped() {
        delegate?.didTapAccept(self)
    }
}

extension UserListCell {
    
    private func setupProfileImage() {
        profileImage.image = UIImage(systemName: "person.crop.circle")
        profileImage.layer.cornerRadius = 25
        profileImage.clipsToBounds = true
    }
    
    private func setupNicknameLabel() {
        nicknameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    private func setupDateLabel() {
        dateLabel.textColor = .gray
    }
    
    private func setupAcceptButton() {
        var config = UIButton.Configuration.filled()
        config.title = "수락"
        config.attributedTitle?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        config.baseBackgroundColor = .green
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 25, bottom: 8, trailing: 25)
        acceptButton.configuration = config
    }
    
    private func setupLayout() {
        contentView.addSubview(profileImage)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(acceptButton)
        
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
            padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 0)
        )
        dateLabel.anchor(
            top: nicknameLabel.bottomAnchor,
            leading: profileImage.trailingAnchor,
            bottom: contentView.bottomAnchor,
            padding: UIEdgeInsets(top: 5, left: 10, bottom: 7, right: 0)
        )
        acceptButton.anchor(
            trailing: contentView.trailingAnchor,
            centerY: contentView.centerYAnchor
        )
    }
    
}

extension UserListCell {
    
    func configure(user: UserProfile, showAcceptButton: Bool) {
        nicknameLabel.text = user.nickname
        dateLabel.text = Date().formatted()
        acceptButton.isHidden = !showAcceptButton
    }
    
}
