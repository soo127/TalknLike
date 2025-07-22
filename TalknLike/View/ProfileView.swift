//
//  ProfileView.swift
//  TalknLike
//
//  Created by 이상수 on 7/21/25.
//

import UIKit

final class ProfileView: UIView {

    let tableView = UITableView(frame: .zero, style: .grouped)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        tableView.register(ProfileMenuCell.self, forCellReuseIdentifier: "ProfileMenuCell")

        tableView.tableHeaderView = makeProfileHeader()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func makeProfileHeader() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let profileImageView = UIImageView()
        profileImageView.backgroundColor = .lightGray
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false

        let nicknameLabel = UILabel()
        nicknameLabel.font = .boldSystemFont(ofSize: 20)
        nicknameLabel.text = "닉네임"

        let introLabel = UILabel()
        introLabel.font = .systemFont(ofSize: 14)
        introLabel.textColor = .secondaryLabel
        introLabel.text = "자기소개를 해보세요."

        let editButton = UIButton(type: .system)
        editButton.setTitle("편집", for: .normal)

        let textStack = UIStackView(arrangedSubviews: [nicknameLabel, introLabel])
        textStack.axis = .vertical
        textStack.spacing = 4

        let horizontalStack = UIStackView(arrangedSubviews: [profileImageView, textStack, editButton])
        horizontalStack.spacing = 16
        horizontalStack.alignment = .center
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(horizontalStack)

        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),

            horizontalStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            horizontalStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            horizontalStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])

        // tableHeaderView는 오토레이아웃 지원 x -> frame 기반 직접 설정
        let width = UIScreen.main.bounds.width
        let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        let height = container.systemLayoutSizeFitting(targetSize).height
        container.frame = CGRect(x: 0, y: 0, width: width, height: height)

        return container
    }

    
}
