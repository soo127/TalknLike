//
//  FindPwViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/16/25.
//

import UIKit
import FirebaseAuth

final class FindPwViewController: UIViewController {
    
    private let findPwView = FindPwView()
    
    override func loadView() {
        view = findPwView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findPwView.okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
    }
    
    @objc private func okButtonTapped() {
        guard let email = findPwView.emailField.text, !email.isEmpty else {
            showToast(message: "이메일을 입력해주세요.")
            return
        }
        sendPasswordReset(email: email)
    }
    
    private func sendPasswordReset(email: String) {
        Task { @MainActor in
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
                showPasswordResetAlert()
            } catch {
                showToast(message: "비밀번호 재설정 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func showPasswordResetAlert() {
        let alert = UIAlertController(
            title: "이메일 전송 완료",
            message: "비밀번호 재설정 이메일이 발송되었습니다.\n이메일을 확인하여 비밀번호를 재설정해주세요.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
    
}
