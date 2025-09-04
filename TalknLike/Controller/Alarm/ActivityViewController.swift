//
//  ActivityViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/24/25.
//

import UIKit

final class ActivityViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private var notifications: [NotificationDisplayModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "활동"
        setupTableView()
        layoutTableView()
        fetchNotifications()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
    }
    
    private func layoutTableView() {
        tableView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor
        )
    }
    
    private func fetchNotifications() {
        Task {
            let notifications = try await NotificationManager.fetchNotifications()
            let profilesDict = try await FirestoreService.fetchProfiles(uids: notifications.map { $0.senderID })
            
            self.notifications = notifications.compactMap { noti in
                guard let profile = profilesDict[noti.senderID] else {
                    return nil
                }
                return NotificationDisplayModel(item: noti, profile: profile)
            }
            self.tableView.reloadData()
        }
    }

}

extension ActivityViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as? NotificationCell else {
            return UITableViewCell()
        }
        let notification = notifications[indexPath.row]
        let item = notification.item, profile = notification.profile
        cell.configure(item: item, profile: profile)
        Task { @MainActor in
            let image = await ImageLoader.loadImage(from: profile.photoURL)
            if tableView.indexPath(for: cell) == indexPath {
                cell.profileImageView.image = image
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let postID = notifications[indexPath.row].item.postID else {
            showToast(message: "해당 게시글을 불러오는데 실패했어요.")
            return
        }
        navigationController?.pushViewController(NotificationPostViewController(postID: postID), animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (action, view, completion) in
            self?.deleteNotification(at: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    private func deleteNotification(at indexPath: IndexPath) {
        guard let documentID = notifications[indexPath.row].item.documentID else {
            showToast(message: "삭제에 실패하였습니다.")
            return
        }
        Task { @MainActor in
            try await NotificationManager.deleteNotification(documentID: documentID)
            notifications.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
