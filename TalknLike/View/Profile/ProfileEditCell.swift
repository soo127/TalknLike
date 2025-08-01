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
        setupTitleLabel()
        setupIcon()
        setupValueLabel()
    }

}

extension ProfileEditCell {
    
    private func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 16)
        
        contentView.addSubview(titleLabel)
        titleLabel.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            padding: UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        )
    }
    
    private func setupIcon() {
        accessoryIcon.tintColor = .systemGray
        accessoryIcon.contentMode = .scaleAspectFit
        
        contentView.addSubview(accessoryIcon)
        accessoryIcon.anchor(
            top: contentView.topAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        )
    }
    
    private func setupValueLabel() {
        valueLabel.textColor = .secondaryLabel
        valueLabel.textAlignment = .right
        valueLabel.font = .systemFont(ofSize: 15)

        contentView.addSubview(valueLabel)
        valueLabel.anchor(
            top: contentView.topAnchor,
            bottom: contentView.bottomAnchor,
            trailing: accessoryIcon.leadingAnchor,
            padding: UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 8)
        )
    }
    
}
