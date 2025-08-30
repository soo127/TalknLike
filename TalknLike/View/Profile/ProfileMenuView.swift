//
//  ProfileMenuView.swift
//  TalknLike
//
//  Created by 이상수 on 8/30/25.
//

import UIKit

final class ProfileMenuView: UIView {
    
    private let stackView = UIStackView()
    
    var menuItems: [(String, UIImage?)] = [] {
        didSet { updateMenuItems() }
    }
    
    var onMenuTap: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupStackView()
        setupLayout()
    }
    
    private func setupStackView() {
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        stackView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor
        )
    }
    
    private func updateMenuItems() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, (title, image)) in menuItems.enumerated() {
            let menuItemView = createMenuItemView(title: title, image: image, index: index)
            stackView.addArrangedSubview(menuItemView)
        }
    }
    
    private func createMenuItemView(title: String, image: UIImage?, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBackground
        button.tag = index
        
        let iconView = UIImageView(image: image)
        iconView.tintColor = .label
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let chevronView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronView.tintColor = .systemGray2
        chevronView.contentMode = .scaleAspectFit
        chevronView.translatesAutoresizingMaskIntoConstraints = false
        
        let separatorView = UIView()
        separatorView.backgroundColor = .separator
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(iconView)
        button.addSubview(titleLabel)
        button.addSubview(chevronView)
        button.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 20),
            iconView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            
            chevronView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20),
            chevronView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            chevronView.widthAnchor.constraint(equalToConstant: 18),
            chevronView.heightAnchor.constraint(equalToConstant: 18),
            
            separatorView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        button.addTarget(self, action: #selector(menuButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }

    @objc private func menuButtonTapped(_ sender: UIButton) {
        onMenuTap?(sender.tag)
    }
    
}
