//
//  ProfileView.swift
//  TalknLike
//
//  Created by 이상수 on 8/30/25.
//

import UIKit

final class ProfileView: UIView {
    
    let scrollView = UIScrollView()
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
        layoutScrollView()
    }
    
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.addSubview(headerView)
        scrollView.addSubview(menuView)

        scrollView.backgroundColor = .systemBackground
        scrollView.alwaysBounceVertical = true
    }

    private func layoutScrollView() {
        scrollView.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor
        )

        headerView.anchor(
            top: scrollView.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        )

        menuView.anchor(
            top: headerView.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0)
        )
    }
    
}
