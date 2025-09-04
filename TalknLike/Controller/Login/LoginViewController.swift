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
        case .findPw:
            self.didTapFindPwButton()
        }
    }

    private func didTapLoginButton() {
        view.endEditing(true)
        guard let email = loginView.emailField.text,
              let pw = loginView.passwordField.text else {
            return
        }
        Task { @MainActor in
            do {
                let result = try await Auth.auth().signIn(withEmail: email, password: pw)
                if !result.user.isEmailVerified {
                    try Auth.auth().signOut()
                    showEmailVerificationRequiredAlert()
                    return
                }
                
                showToast(message: "로그인 성공")
                await onLoginSuccess()
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = MainViewController()
                }
            } catch {
                showToast(message: "로그인 실패")
            }
        }
    }

    private func showEmailVerificationRequiredAlert() {
        let alert = UIAlertController(
            title: "이메일 인증 필요",
            message: "로그인하려면 먼저 이메일 인증을 완료해주세요.\n이메일을 확인하고 인증 링크를 클릭한 후 다시 로그인해주세요.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        
        present(alert, animated: true)
    }

    func onLoginSuccess() async {
        await CurrentUserStore.shared.fetchCurrentUser()
        await CurrentUserStore.shared.currentUser
            .handleSome {
                try? await PostStore.shared.loadPosts(for: $0.uid)
                try? await FollowManager.shared.fetchFollowRequests()
                try? await FollowManager.shared.fetchFollowers(for: $0.uid)
                try? await FollowManager.shared.fetchFollowings(for: $0.uid)
            }
    }

    private func didTapSignUpButton() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    private func didTapFindPwButton() {
        navigationController?.pushViewController(FindPwViewController(), animated: true)
    }
    
}
