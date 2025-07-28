//
//  ProfileEditCell.swift
//  TalknLike
//
//  Created by 이상수 on 7/24/25.
//

import UIKit

final class ProfileEditCell: UITableViewCell {

    let titleLabel = UILabel()
    let valueLabel = UILabel()
    let accessoryIcon = UIImageView(image: UIImage(systemName: "chevron.right"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, value: String?) {
        titleLabel.text = title
        valueLabel.text = value
    }

    private func setup() {
        [titleLabel, valueLabel, accessoryIcon].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        accessoryIcon.tintColor = .systemGray
        accessoryIcon.contentMode = .scaleAspectFit
        valueLabel.textColor = .secondaryLabel
        valueLabel.textAlignment = .right
        titleLabel.font = .systemFont(ofSize: 16)
        valueLabel.font = .systemFont(ofSize: 15)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            accessoryIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            accessoryIcon.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            accessoryIcon.widthAnchor.constraint(equalToConstant: 12),
            accessoryIcon.heightAnchor.constraint(equalToConstant: 18),

            valueLabel.trailingAnchor.constraint(equalTo: accessoryIcon.leadingAnchor, constant: -8),
            valueLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8)
        ])
    }

}
