//
//  ProfileMenuCell.swift
//  TalknLike
//
//  Created by 이상수 on 7/22/25.
//

import UIKit

final class ProfileMenuCell: UITableViewCell {

    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private var hStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, image: UIImage?) {
        iconView.image = image
        titleLabel.text = title
    }
    
    private func setup() {
        setupIconView()
        setupTitleLabel()
        setupLayout()
    }
    
}

extension ProfileMenuCell {
    
    private func setupIconView() {
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .label
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .label
    }
    
    private func setupLayout() {
        hStack = UIStackView.make(
            views: [iconView, titleLabel],
            axis: .horizontal,
            spacing: 12
        )
        contentView.addSubview(hStack)
        hStack.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            padding: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        )
    }
    
}
