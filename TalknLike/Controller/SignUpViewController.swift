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
        [signUpView.idField, signUpView.passwordField, signUpView.passwordCheckField, signUpView.phoneField].forEach {
            $0.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        }
        signUpView.signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }

    @objc private func textFieldsChanged() {
        let filled = !signUpView.idField.text!.isEmpty &&
                     !signUpView.passwordField.text!.isEmpty &&
                     !signUpView.passwordCheckField.text!.isEmpty &&
                     !signUpView.phoneField.text!.isEmpty

        signUpView.signUpButton.isEnabled = filled
        signUpView.signUpButton.alpha = filled ? 1.0 : 0.5
    }

    @objc private func signUpTapped() {
        let alert = UIAlertController(title: "가입 완료", message: "환영합니다!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
}

