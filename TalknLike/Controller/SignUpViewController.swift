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
    func didChangeTextFields()
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
    
}

extension SignUpViewController: SignUpViewDelegate {
    
    func didTapVerifyButton() {
        
    }
    
    func didTapSignUpButton() {
        let alert = UIAlertController(title: "가입 완료", message: "환영합니다!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    func didChangeTextFields() {
        let filled = true // 조건 붙이기
        if filled {
            signUpView.setSignUpButton()
        }
    }
    
}
