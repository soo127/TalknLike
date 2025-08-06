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
        setupHeader()
        setupTableView()
    }
    
}

extension ProfileEditView {
    
    private func setupHeader() {
        header.backgroundColor = .systemBackground
        header.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 180)
        setupProfileImageView()
        setupCameraButton()
    }
    
    private func setupTableView() {
        tableView.register(ProfileEditCell.self, forCellReuseIdentifier: "ProfileEditCell")
        tableView.tableHeaderView = header
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
    
    private func setupProfileImageView() {
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        
        header.addSubview(profileImageView)
        profileImageView.anchor(
            centerX: header.centerXAnchor,
            centerY: header.centerYAnchor
        )
        profileImageView.anchor(
            width: 80,
            height: 80
        )
    }
    
    private func setupCameraButton() {
        let cameraConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let cameraImage = UIImage(systemName: "camera", withConfiguration: cameraConfig)
        cameraButton.setImage(cameraImage, for: .normal)
        cameraButton.tintColor = .white
        cameraButton.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        cameraButton.layer.cornerRadius = 40
        
        header.addSubview(cameraButton)
        cameraButton.anchor(
            centerX: header.centerXAnchor,
            centerY: header.centerYAnchor
        )
        cameraButton.anchor(
            width: 80,
            height: 80
        )
    }
    
}
