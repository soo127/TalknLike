//
//  FollowRequestCell.swift
//  TalknLike
//
//  Created by 이상수 on 8/7/25.
//

import UIKit

protocol FollowRequestCellDelegate: AnyObject {
    func didTapAccept(_ cell: FollowRequestCell)
}

final class FollowRequestCell: UITableViewCell {
    
    weak var delegate: FollowRequestCellDelegate?
    
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
        setupSubviews()
        setupButtonActions()
        setupLayout()
    }
    
}

extension FollowRequestCell {
    
    private func setupSubviews() {
        setupProfileImage()
        setupNicknameLabel()
        setupDateLabel()
        setupAcceptButton()
    }
    
    private func setupProfileImage() {
        contentView.addSubview(profileImage)
        profileImage.image = UIImage(systemName: "person.crop.circle")
        profileImage.layer.cornerRadius = 25
        profileImage.clipsToBounds = true
    }
    
    private func setupNicknameLabel() {
        contentView.addSubview(nicknameLabel)
        nicknameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    private func setupDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.textColor = .gray
    }
    
    private func setupAcceptButton() {
        contentView.addSubview(acceptButton)
        var config = UIButton.Configuration.filled()
        config.title = "수락"
        config.attributedTitle?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        config.baseBackgroundColor = .green
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 25, bottom: 8, trailing: 25)
        acceptButton.configuration = config
    }
    
    private func setupButtonActions() {
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }
    
}

extension FollowRequestCell {
    
    private func setupLayout() {
        layoutProfileImage()
        layoutNicknameLabel()
        layoutDateLabel()
        layoutAcceptButton()
    }
    
    private func layoutProfileImage() {
        profileImage.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            padding: UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 0),
            width: 50,
            height: 50
        )
    }
    
    private func layoutNicknameLabel() {
        nicknameLabel.anchor(
            top: profileImage.topAnchor,
            leading: profileImage.trailingAnchor,
            padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 0)
        )
    }
    
    private func layoutDateLabel() {
        dateLabel.anchor(
            top: nicknameLabel.bottomAnchor,
            leading: profileImage.trailingAnchor,
            bottom: contentView.bottomAnchor,
            padding: UIEdgeInsets(top: 5, left: 10, bottom: 7, right: 0)
        )
    }
    
    private func layoutAcceptButton() {
        acceptButton.anchor(
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10),
            centerY: contentView.centerYAnchor
        )
    }
    
}

extension FollowRequestCell {
    
    @objc private func acceptButtonTapped() {
        delegate?.didTapAccept(self)
    }
    
}

extension FollowRequestCell {
    
    func configure(user: UserProfile, date: Date, showAcceptButton: Bool) {
        nicknameLabel.text = user.nickname
        dateLabel.text = date.formatted()
        acceptButton.isHidden = !showAcceptButton
    }
    
}
