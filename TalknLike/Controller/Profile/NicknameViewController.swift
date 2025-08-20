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
        let nickname = nicknameEditView.textField.text
        if !nicknameEditView.isAvailableNickname(nickname) {
            showToast(message: "닉네임 글자 수를 확인해주세요.")
            return
        }
        do {
            try CurrentUserStore.shared.update(nickname: nickname)
            showToast(message: "업데이트 성공")
        } catch {
            showToast(message: "업데이트 실패")
        }
        navigationController?.popViewController(animated: true)
    }
    
}
