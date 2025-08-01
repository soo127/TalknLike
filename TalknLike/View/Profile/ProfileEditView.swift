//
//  ProfileEditView.swift
//  TalknLike
//
//  Created by 이상수 on 7/22/25.
//

import UIKit

final class ProfileEditView: UIView {

    let cameraButton = UIButton()
    let imageButton = UIButton()
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
        setupImageButton()
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
    
    private func setupImageButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .regular)
        let image = UIImage(systemName: "person.crop.circle", withConfiguration: config)
        imageButton.setImage(image, for: .normal)
        imageButton.imageView?.layer.cornerRadius = 40
        
        header.addSubview(imageButton)
        imageButton.anchor(
            centerX: header.centerXAnchor,
            centerY: header.centerYAnchor
        )
    }
    
    private func setupCameraButton() {
        let cameraConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)
        let cameraImage = UIImage(systemName: "camera.circle.fill", withConfiguration: cameraConfig)
        cameraButton.setImage(cameraImage, for: .normal)
        cameraButton.tintColor = .black
        
        header.addSubview(cameraButton)
        cameraButton.anchor(
            bottom: imageButton.bottomAnchor,
            trailing: imageButton.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: -4, right: -4)
        )
    }
    
}
