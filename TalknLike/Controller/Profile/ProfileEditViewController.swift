//
//  ProfileEditViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/25/25.
//

import UIKit
import Combine
import PhotosUI
import Supabase

final class ProfileEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let profileEditView = ProfileEditView()
    private let menu = ProfileEditItem.allCases
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
        profileEditView.tableView.dataSource = self
        profileEditView.tableView.delegate = self
        profileEditView.tableView.register(ProfileEditCell.self, forCellReuseIdentifier: ProfileEditCell.identifier)
    }

    private func setupActions() {
        profileEditView.cameraButton.addTarget(self, action: #selector(didTapProfile), for: .touchUpInside)
    }

    private func bindUser() {
        CurrentUserStore.shared.userPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.profileEditView.configure(user: user)
            }
            .store(in: &cancellables)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileEditCell.identifier,
            for: indexPath
        ) as? ProfileEditCell else {
            return UITableViewCell()
        }
        let item = menu[indexPath.row]
        let value: String?
        
        switch item {
        case .nickname:
            value = CurrentUserStore.shared.currentUser?.nickname
        case .bio:
            value = CurrentUserStore.shared.currentUser?.bio
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
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
}

extension ProfileEditViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        defer {
            picker.dismiss(animated: true)
        }
        
        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            guard let selectedImage = image as? UIImage,
                  let uid = CurrentUserStore.shared.currentUser?.uid else {
                return
            }
            
            Task {
                do {
                    let fileName = "\(uid).jpg"
                    try await SupabaseManager.uploadImage(
                        selectedImage,
                        fileName: fileName,
                        bucket: .profileImages
                    )
                    let newPhotoURL = SupabaseManager.publicImageURL(fileName: fileName, bucket: .profileImages) + "?t=\(Int(Date().timeIntervalSince1970))"
                    try CurrentUserStore.shared.update(photoURL: newPhotoURL)
                } catch {
                    print("프로필 이미지 업로드 실패: \(error)")
                }
            }
        }
    }

}
