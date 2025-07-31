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
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping

        nicknameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        dateLabel.textColor = .gray
       
        profileImage.layer.cornerRadius = 30
        profileImage.clipsToBounds = true

        [profileImage, nicknameLabel, dateLabel, contentLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            profileImage.widthAnchor.constraint(equalToConstant: 60),
            profileImage.heightAnchor.constraint(equalToConstant: 60),

            nicknameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 12),
            nicknameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor),

            dateLabel.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: 8),
            dateLabel.centerYAnchor.constraint(equalTo: nicknameLabel.centerYAnchor),

            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
}
