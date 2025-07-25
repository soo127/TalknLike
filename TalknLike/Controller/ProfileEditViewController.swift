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
    private let menuItems: [(String, String?)] = [
        ("닉네임", nil),
        ("자기소개", "안녕하세요"),
    ]
    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        view = profileEditView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        profileEditView.tableView.delegate = self
        profileEditView.tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditCell", for: indexPath) as? ProfileEditCell else {
            return UITableViewCell()
        }
        let (title, value) = menuItems[indexPath.row]
        cell.configure(title: title, value: value)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(SelfIntroductionViewController(), animated: true)
        // TODO: 이동 처리
    }
    
}
