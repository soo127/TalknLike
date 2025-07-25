//
//  ProfileEditView.swift
//  TalknLike
//
//  Created by 이상수 on 7/22/25.
//

import UIKit

final class ProfileEditView: UIView {

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
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(ProfileEditCell.self, forCellReuseIdentifier: "ProfileEditCell")
        tableView.tableHeaderView = profileEditor()
    }

    private func profileEditor() -> UIView {
        let header = UIView()
        let imageButton = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .regular)
        let image = UIImage(systemName: "camera.circle", withConfiguration: config)
        imageButton.setImage(image, for: .normal)
        imageButton.tintColor = .gray
        imageButton.imageView?.contentMode = .scaleAspectFit
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        
        header.addSubview(imageButton)

        NSLayoutConstraint.activate([
            imageButton.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            imageButton.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            imageButton.widthAnchor.constraint(equalToConstant: 80),
            imageButton.heightAnchor.constraint(equalToConstant: 80),
        ])
        
        header.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150)
        return header
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}

