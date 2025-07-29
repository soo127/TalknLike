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
                self?.user = user
                self?.profileEditView.tableView.reloadData()
                Task { [weak self] in
                    let image = try await ImageLoader.loadImage(from: user.photoURL)
                    let resizedImage = image?.resized(to: CGSize(width: 80, height: 80))
                    self?.profileEditView.imageButton.setImage(resizedImage, for: .normal)
                }
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
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let selectedImage = image as? UIImage,
                  let imageData = selectedImage.jpegData(compressionQuality: 0.5),
            let user = self?.user else {
                return
            }
                                    
            Task {
                do {
                    let fileName = "\(user.uid).jpg"
                    try await SupabaseManager.imageBucket()
                        .upload(fileName, data: imageData, options: FileOptions(contentType: "image/jpeg"))
                    
                    try await CurrentUserStore.shared.update(
                        photoURL: SupabaseManager.publicImageURL(for: fileName)
                    )
                    print("이미지 업로드 성공")
                } catch {
                    print("이미지 업로드 실패: \(error)")
                }
            }
        }
    }
    
}
