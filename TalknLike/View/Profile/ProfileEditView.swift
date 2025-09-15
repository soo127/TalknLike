//
//  ProfileEditView.swift
//  TalknLike
//
//  Created by 이상수 on 7/22/25.
//

import UIKit

final class ProfileEditView: UIView {

    let cameraButton = UIButton()
    let profileImageView = UIImageView()
    let tableView = UITableView(frame: .zero, style: .grouped)
    private let header = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupSubviews()
        setupLayout()
    }
    
}

extension ProfileEditView {
    
    private func setupSubviews() {
        setupHeader()
        setupTableView()
        setupProfileImageView()
        setupCameraButton()
    }
    
    private func setupHeader() {
        addSubview(tableView)
        header.backgroundColor = .systemBackground
        header.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 180)
    }
    
    private func setupTableView() {
        tableView.tableHeaderView = header
        tableView.backgroundColor = .systemBackground
    }
    
    private func setupProfileImageView() {
        header.addSubview(profileImageView)
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
    }
    
    private func setupCameraButton() {
        header.addSubview(cameraButton)
        let cameraConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let cameraImage = UIImage(systemName: "camera", withConfiguration: cameraConfig)
        cameraButton.setImage(cameraImage, for: .normal)
        cameraButton.tintColor = .white
        cameraButton.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        cameraButton.layer.cornerRadius = 40
    }
    
}

extension ProfileEditView {
    
    private func setupLayout() {
        layoutProfileImageView()
        layoutCameraButton()
        layoutTableView()
    }
    
    private func layoutProfileImageView() {
        profileImageView.anchor(
            width: 80,
            height: 80,
            centerX: header.centerXAnchor,
            centerY: header.centerYAnchor
        )
    }
    
    private func layoutCameraButton() {
        cameraButton.anchor(
            width: 80,
            height: 80,
            centerX: header.centerXAnchor,
            centerY: header.centerYAnchor
        )
    }
    
    private func layoutTableView() {
        tableView.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        )
    }
    
}
