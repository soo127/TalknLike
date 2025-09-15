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
        setupSubviews()
        setupLayout()
    }

}

extension ProfileEditCell {
    
    private func setupSubviews() {
        setupTitleLabel()
        setupIcon()
        setupValueLabel()
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupIcon() {
        contentView.addSubview(accessoryIcon)
        accessoryIcon.tintColor = .systemGray
        accessoryIcon.contentMode = .scaleAspectFit
        accessoryIcon.setContentCompressionResistancePriority(.required, for: .horizontal)
        accessoryIcon.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupValueLabel() {
        contentView.addSubview(valueLabel)
        valueLabel.textColor = .secondaryLabel
        valueLabel.textAlignment = .right
        valueLabel.font = .systemFont(ofSize: 15)
        valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
}

extension ProfileEditCell {
    
    private func setupLayout() {
        layoutTitleLabel()
        layoutIcon()
        layoutValueLabel()
    }
    
    private func layoutTitleLabel() {
        titleLabel.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            padding: UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0),
        )
    }
    
    private func layoutIcon() {
        accessoryIcon.anchor(
            top: contentView.topAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        )
    }
    
    private func layoutValueLabel() {
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
