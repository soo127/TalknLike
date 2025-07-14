//
//  SignUpViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/14/25.
//

import UIKit

final class SignUpViewController: UIViewController {

    private let signUpView = SignUpView()

    override func loadView() {
        view = signUpView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    }

    @objc private func handleSignUp() {
        let email = signUpView.idField.text ?? ""
        let password = signUpView.passwordField.text ?? ""

        if UserValidator.isValid(email: email, password: password) {
            let newUser = User(email: email, password: password)
            print("회원가입 성공: \(newUser)")
            // 화면 전환 or 알림 띄우기
        } else {
            showAlert(message: "올바른 이메일과 비밀번호를 입력하세요.")
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
}


