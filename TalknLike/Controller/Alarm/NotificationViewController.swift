//
//  NotificationViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/24/25.
//

import UIKit

final class NotificationViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private var notifications: [NotificationItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "알림"

        setupTableView()
        Task {
            do {
                self.notifications = try await NotificationManager.fetchNotifications(
                    receiverID: CurrentUserStore.shared.currentUser!.uid
                )
                self.tableView.reloadData()
            } catch {
                print("Failed to fetch notifications: \(error)")
            }
        }
                
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
    }

}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as? NotificationCell else {
            return UITableViewCell()
        }
        let notification = notifications[indexPath.row]

        cell.configure(with: notification)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
