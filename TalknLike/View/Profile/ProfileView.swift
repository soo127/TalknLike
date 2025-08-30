//
//  ProfileView.swift
//  TalknLike
//
//  Created by 이상수 on 8/30/25.
//

import UIKit

final class ProfileView: UIView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let headerView = ProfileHeaderView()
    let menuView = ProfileMenuView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupScrollView()
        setupContentView()
        setupSubviews()
        setupLayout()
    }
    
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.backgroundColor = .systemBackground
    }
    
    private func setupSubviews() {
        contentView.addSubview(headerView)
        contentView.addSubview(menuView)
    }
    
    private func setupLayout() {
        scrollView.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor
        )
        
        contentView.anchor(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            bottom: scrollView.bottomAnchor,
            trailing: scrollView.trailingAnchor
        )
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        headerView.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        )
        
        menuView.anchor(
            top: headerView.bottomAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0)
        )
    }
    
}
