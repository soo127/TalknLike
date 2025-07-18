//
//  LoginViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/14/25.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func didTapLoginButton()
    func didTapSignUpButton()
    func didTapFindIdButton()
    func didTapFindPwButton()
}

final class LoginViewController: UIViewController {
    
    private let loginView = LoginView()

    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.delegate = self
    }
    
}

extension LoginViewController: LoginViewDelegate {
    
    func didTapLoginButton() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }

    func didTapSignUpButton() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    func didTapFindIdButton() {
        navigationController?.pushViewController(FindIdViewController(), animated: true)
    }
    
    func didTapFindPwButton() {
        navigationController?.pushViewController(IdCheckViewController(), animated: true)
    }
    
}
