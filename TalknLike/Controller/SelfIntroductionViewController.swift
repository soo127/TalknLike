//
//  SelfIntroductionViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/25/25.
//

import UIKit

final class SelfIntroductionViewController: UIViewController {

    let selfIntroductionView = SelfIntroductionView()
    
    override func loadView() {
        view = selfIntroductionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationItem.title = "자기소개"
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
                    nickname: "테스트용22",
                    bio: selfIntroductionView.textView.text,
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
