//
//  ProfileEditCell.swift
//  TalknLike
//
//  Created by 이상수 on 7/24/25.
//

import UIKit

final class ProfileEditCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let accessoryIcon = UIImageView(image: UIImage(systemName: "chevron.right"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupTitleLabel()
        setupIcon()
        setupValueLabel()
    }

}

extension ProfileEditCell {
    
    private func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupIcon() {
        accessoryIcon.tintColor = .systemGray
        accessoryIcon.contentMode = .scaleAspectFit
        accessoryIcon.setContentCompressionResistancePriority(.required, for: .horizontal)
        accessoryIcon.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupValueLabel() {
        valueLabel.textColor = .secondaryLabel
        valueLabel.textAlignment = .right
        valueLabel.font = .systemFont(ofSize: 15)
        valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(accessoryIcon)
        contentView.addSubview(valueLabel)

        titleLabel.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            padding: UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0),
        )
        accessoryIcon.anchor(
            top: contentView.topAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        )
        valueLabel.anchor(
            top: contentView.topAnchor,
            leading: titleLabel.trailingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: accessoryIcon.leadingAnchor,
            padding: UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 8)
        )
    }
    
}

extension ProfileEditCell {
    
    func configure(title: String, value: String?) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
}
