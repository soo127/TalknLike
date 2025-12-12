//
//  NotificationViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/24/25.
//

import UIKit

final class NotificationViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "알림"
        setupTableView()
        layoutTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
    }

    private func layoutTableView() {
        tableView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor
        )
    }
    
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = indexPath.row == 0 ? "새 팔로우 요청" : "활동"
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationController?.pushViewController(NewFollowerViewController(), animated: true)
        } else {
            navigationController?.pushViewController(ActivityViewController(), animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
