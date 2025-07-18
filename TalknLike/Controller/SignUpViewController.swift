//
//  SignUpViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/14/25.
//

import UIKit
import Combine
import FirebaseFirestore


protocol SignUpViewDelegate: AnyObject {
    func didTapVerifyButton()
    func didTapSignUpButton()
    func didChangeEmailFields()
}

final class SignUpViewController: UIViewController {
    
    private let signUpView = SignUpView()
    private let db = Firestore.firestore()
    
    override func loadView() {
        view = signUpView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.delegate = self
    }
    
}

extension SignUpViewController: SignUpViewDelegate {
    
    func didTapVerifyButton() {
        
    }
    
    func didTapSignUpButton() {
        let alert = UIAlertController(title: "가입 완료", message: "환영합니다!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    func didChangeEmailFields() {
        guard let text = signUpView.emailField.text else { return }
        signUpView.emailVerifyButton.isEnabled = !text.isEmpty
        signUpView.emailVerifyButton.alpha = text.isEmpty ? 0.5 : 1.0
    }

}
