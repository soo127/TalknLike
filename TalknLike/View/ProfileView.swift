//
//  ProfileView.swift
//  TalknLike
//
//  Created by 이상수 on 7/21/25.
//

import UIKit

final class ProfileView: UIView {

    let tableView = UITableView(frame: .zero, style: .grouped)
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let introLabel = UILabel()

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

        profileImageView.backgroundColor = .lightGray
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false

        nicknameLabel.font = .boldSystemFont(ofSize: 20)
        nicknameLabel.text = "닉네임"

        introLabel.font = .systemFont(ofSize: 14)
        introLabel.textColor = .secondaryLabel
        introLabel.text = "자기소개를 해보세요."

        let editButton = UIButton(type: .system)
        editButton.setTitle("편집", for: .normal)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        
        let textStack = UIStackView(arrangedSubviews: [nicknameLabel, introLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(profileImageView)
        container.addSubview(textStack)
        container.addSubview(editButton)

        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            profileImageView.topAnchor.constraint(equalTo: container.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            editButton.topAnchor.constraint(equalTo: container.topAnchor),
            editButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),

            textStack.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            textStack.topAnchor.constraint(equalTo: container.topAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])

        // tableHeaderView는 container의 내부 subviews의 Auto Layout에 기반해서 높이 계산
        let width = UIScreen.main.bounds.width
        let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        let height = container.systemLayoutSizeFitting(targetSize).height
        container.frame = CGRect(x: 0, y: 0, width: width, height: height)

        return container
    }
    
    @objc private func editProfile() {
        Task {
            do {
                try await CurrentUserStore.shared.update(
                    nickname: "테스트용22",
                    bio: "입니다22"
                )
                print("프로필 업데이트 완료")
            } catch {
                print("업데이트 실패: \(error.localizedDescription)")
            }
        }
    }

}
