//
//  FollowingFeedView.swift
//  TalknLike
//
//  Created by 이상수 on 8/13/25.
//

import UIKit

final class FollowingFeedView: UIView {

    let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(tableView)
        tableView.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 12, left: 16, bottom: 0, right: 16),
        )
    }
    
}
