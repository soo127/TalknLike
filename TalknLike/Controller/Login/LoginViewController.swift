//
//  LoginViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/14/25.
//

import UIKit
import FirebaseAuth

protocol LoginViewDelegate: AnyObject {
    func didTapButton(_ button: LoginViewController.Button)
}

extension LoginViewController {
    
    enum Button {
        case login
        case signUp
        case findId
        case findPw
    }
    
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
    
    func didTapButton(_ button: LoginViewController.Button) {
        switch button {
        case .login:
            self.didTapLoginButton()
        case .signUp:
            self.didTapSignUpButton()
        case .findId:
            self.didTapFindIdButton()
        case .findPw:
            self.didTapFindPwButton()
        }
    }

    private func didTapLoginButton() {
        guard let email = loginView.emailField.text,
              let pw = loginView.passwordField.text else {
            return
        }
        Task { @MainActor in
            do {
                try await Auth.auth().signIn(withEmail: email, password: pw)
                await onLoginSuccess()
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = MainViewController()
                }
            } catch {
                showToast(message: "로그인 실패")
            }
        }
    }
    
    func onLoginSuccess() async {
        await CurrentUserStore.shared.fetchCurrentUser()
        await CurrentUserStore.shared.currentUser
            .handleSome {
                try? await PostStore.shared.fetchPosts(for: $0.uid)
                try? await FollowManager.shared.fetchFollowRequests(for: $0.uid)
                try? await FollowManager.shared.fetchFollowers(for: $0.uid)
                try? await FollowManager.shared.fetchFollowings(for: $0.uid)
            }
    }

    private func didTapSignUpButton() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    private func didTapFindIdButton() {
        navigationController?.pushViewController(FindIdViewController(), animated: true)
    }
    
    private func didTapFindPwButton() {
        navigationController?.pushViewController(IdCheckViewController(), animated: true)
    }
    
}
