//
//  SearchUserView.swift
//  TalknLike
//
//  Created by 이상수 on 8/6/25.
//

import UIKit

final class SearchUserView: UIView {

    let searchTextField = UITextField()
    let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTextField() {
        searchTextField.placeholder = "사용자 검색"
        searchTextField.backgroundColor = .systemGray6
        searchTextField.layer.cornerRadius = 10
        searchTextField.clipsToBounds = true

        searchTextField.setLeftIcon(
            image: UIImage(systemName:"magnifyingglass"),
            leftPadding: 8,
            rightPadding: 5
        )
        searchTextField.setRightIcon(
            image: UIImage(systemName: "x.circle.fill"),
            leftPadding: 5,
            rightPadding: 8
        )
    }
    
    private func setupLayout() {
        addSubview(searchTextField)
        addSubview(tableView)

        searchTextField.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 12, left: 16, bottom: 0, right: 16),
            height: 40
        )
        tableView.anchor(
            top: searchTextField.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0),
        )
    }
    
}
