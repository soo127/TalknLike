//
//  SignUpViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/14/25.
//

import UIKit

protocol SignUpViewDelegate: AnyObject {
    func didTapVerifyButton()
    func didTapSignUpButton()
    func textFieldsDidChange()
}

final class SignUpViewController: UIViewController {
    
    private let signUpView = SignUpView()

    override func loadView() {
        view = signUpView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.delegate = self
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

extension SignUpViewController: SignUpViewDelegate {
    
    func didTapVerifyButton() {
        
    }
    
    func didTapSignUpButton() {
        
    }
    
    func textFieldsDidChange() {
        
    }
    
}
