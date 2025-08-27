//
//  SearchUserViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/6/25.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

final class SearchUserViewController: UIViewController {
    
    private let searchUserView = SearchUserView()
    private var searchedUsers: [UserProfile] = []
    private var followingUserIds: Set<String> = []
    
    override func loadView() {
        view = searchUserView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchField()
        loadFollowingUsers()
    }
    
    private func setupTableView() {
        searchUserView.tableView.dataSource = self
        searchUserView.tableView.delegate = self
        searchUserView.tableView.register(SearchUserCell.self, forCellReuseIdentifier: "SearchUserCell")
    }
    
    private func setupSearchField() {
        searchUserView.searchTextField.delegate = self
        searchUserView.searchTextField.returnKeyType = .search
    }
    
    private func loadFollowingUsers() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        Task { @MainActor in
            do {
                let followingSnapshot = try await Firestore.firestore()
                    .collection("Users")
                    .document(currentUserId)
                    .collection("following")
                    .getDocuments()
                    .documents
                    .map { $0.documentID }
                followingUserIds = Set(followingSnapshot)
            } catch {
                print("팔로잉 목록 로드 중 오류:", error)
            }
        }
    }
    
    func searchUsers(matching keyword: String) async throws {
        let users = try await Firestore.firestore()
            .collection("Users")
            .whereField("nickname", isGreaterThanOrEqualTo: keyword)
            .whereField("nickname", isLessThan: keyword + "\u{f8ff}")
            .limit(to: 20)
            .getDocuments()
            .documents
            .compactMap { try? $0.data(as: UserProfile.self) }
        
        updateTableView(users: users)
    }

    private func updateTableView(users: [UserProfile]) {
        searchedUsers = users
        searchUserView.tableView.reloadData()
    }
    
    private func shouldShowFollowButton(for user: UserProfile) -> Bool {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return false
        }
        if user.uid == currentUserId || followingUserIds.contains(user.uid) {
            return false
        }
        return true
    }
    
}

extension SearchUserViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserCell", for: indexPath) as? SearchUserCell else {
            return UITableViewCell()
        }
        let user = searchedUsers[indexPath.row]
        let shouldShowButton = shouldShowFollowButton(for: user)
        
        cell.delegate = self
        cell.configureSearch(user: user, shouldShowFollowButton: shouldShowButton)
        
        Task { @MainActor in
            let image = await ImageLoader.loadImage(from: user.photoURL)
            if tableView.indexPath(for: cell) == indexPath {
                cell.profileImage.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SearchUserViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let keyword = textField.text, !keyword.isEmpty else {
            return true
        }
        Task {
            do {
                try await searchUsers(matching: keyword)
            } catch {
                print("검색 중 오류 발생:", error)
            }
        }
        return true
    }
}

extension SearchUserViewController: SearchUserCellDelegate {
    
    func didTapButton(_ cell: SearchUserCell) {
        guard let indexPath = searchUserView.tableView.indexPath(for: cell) else {
            return
        }
        let user = searchedUsers[indexPath.row]
        Task {
            do {
                try await FollowManager.shared.sendFollowRequest(to: user)
                
                // 팔로잉 목록에 추가하고 UI 업데이트
                followingUserIds.insert(user.uid)
                
                DispatchQueue.main.async {
                    self.searchUserView.tableView.reloadRows(at: [indexPath], with: .none)
                    self.showToast(message: "친구 요청을 보냈어요.")
                }
            } catch {
                print("searchUserCell error: \(error)")
            }
        }
    }
}
