//
//  LoginViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/14/25.
//

import UIKit
import FirebaseAuth

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
        guard let email = loginView.emailField.text,
              let pw = loginView.passwordField.text else {
            return
        }
        Task { @MainActor in
            do {
                try await Auth.auth().signIn(withEmail: email, password: pw)
                await CurrentUserStore.shared.fetchCurrentUser()
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = MainViewController()
                }
            } catch {
                print("로그인 실패: \(error.localizedDescription)")
            }
        }
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
