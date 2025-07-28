//
//  ProfileEditViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/25/25.
//

import UIKit
import Combine

final class ProfileEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let profileEditView = ProfileEditView()
    private let menu = ProfileEditItem.allCases
    private var user: UserProfile?
    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        view = profileEditView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindUser()
        setupActions()
    }

    private func setupTableView() {
        profileEditView.tableView.delegate = self
        profileEditView.tableView.dataSource = self
    }

    private func setupActions() {
        profileEditView.cameraButton.addTarget(self, action: #selector(didTapProfile), for: .touchUpInside)
        profileEditView.imageButton.addTarget(self, action: #selector(didTapProfile), for: .touchUpInside)
    }

    private func bindUser() {
        CurrentUserStore.shared.userPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                guard let self = self else { return }
                self.user = user
                self.profileEditView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditCell", for: indexPath) as? ProfileEditCell else {
            return UITableViewCell()
        }
        let item = menu[indexPath.row]
        let value: String?
        
        switch item {
        case .nickname:
            value = user?.nickname
        case .bio:
            value = user?.bio
        }
        
        cell.configure(title: item.title, value: value)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = menu[indexPath.row]
        navigationController?.pushViewController(item.destinationViewController(), animated: true)
    }
    
    @objc private func didTapProfile() {
        
    }
    
}
