//
//  NicknameViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/28/25.
//

import UIKit

final class NicknameViewController: UIViewController {

    let nicknameEditView = NicknameEditView()
    
    override func loadView() {
        view = nicknameEditView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        navigationItem.title = "닉네임"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(didTapCancel)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .done,
            target: self,
            action: #selector(didTapSave)
        )
    }

    @objc private func didTapCancel() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapSave() {
        Task {
            do {
                try await CurrentUserStore.shared.update(
                    nickname: nicknameEditView.textField.text,
                    bio: "테스트용 33",
                    photoURL: "person.circle.fill"
                )
                print("프로필 업데이트 완료")
            } catch {
                print("업데이트 실패: \(error.localizedDescription)")
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
}
