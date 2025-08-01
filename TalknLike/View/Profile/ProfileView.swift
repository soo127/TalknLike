//
//  ProfileView.swift
//  TalknLike
//
//  Created by 이상수 on 7/21/25.
//

import UIKit

final class ProfileView: UIView {

    let tableView = UITableView(frame: .zero, style: .grouped)
    let editButton = UIButton(type: .system)
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let introLabel = UILabel()
    var textStack = UIStackView()
    private let header = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        tableView.register(ProfileMenuCell.self, forCellReuseIdentifier: "ProfileMenuCell")
        tableView.tableHeaderView = setupProfileHeader()
        tableView.backgroundColor = .systemBackground
        addSubview(tableView)
        
        tableView.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        )
    }
    
}

extension ProfileView {
    
    private func setupProfileImageView() {
        profileImageView.backgroundColor = .lightGray
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        
        header.addSubview(profileImageView)
        profileImageView.anchor(
            top: header.topAnchor,
            leading: header.leadingAnchor,
            bottom: header.bottomAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0),
            width: 80,
            height: 80,
        )
    }
    
    private func setupNicknameLabel() {
        nicknameLabel.font = .boldSystemFont(ofSize: 20)
        nicknameLabel.text = "닉네임"
    }

    private func setupIntroLabel() {
        introLabel.font = .systemFont(ofSize: 14)
        introLabel.textColor = .secondaryLabel
        introLabel.text = "자기소개를 해보세요."
    }
    
    private func setupTextStack() {
        setupNicknameLabel()
        setupIntroLabel()
        
        textStack = UIStackView.make(
            views: [nicknameLabel, introLabel],
            axis: .vertical,
            spacing: 4
        )
        
        header.addSubview(textStack)
        textStack.anchor(
            top: header.topAnchor,
            leading: profileImageView.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        )
    }
    
    private func setupEditButton() {
        editButton.setTitle("편집", for: .normal)
        
        header.addSubview(editButton)
        editButton.anchor(
            top: header.topAnchor,
            trailing: header.trailingAnchor
        )
    }
    
    private func setupProfileHeader() -> UIView {
        setupProfileImageView()
        setupTextStack()
        setupEditButton()

        // tableHeaderView는 container의 내부 subviews의 Auto Layout에 기반해서 높이 계산
        let width = UIScreen.main.bounds.width
        let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        let height = header.systemLayoutSizeFitting(targetSize).height
        header.frame = CGRect(x: 0, y: 0, width: width, height: height)

        return header
    }

}
