//
//  SignUpViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/14/25.
//

import UIKit
import Combine
import FirebaseAuth
import FirebaseFirestore

protocol SignUpViewDelegate: AnyObject {
    func didTapVerifyButton()
    func didTapSignUpButton()
}

final class SignUpViewController: UIViewController {
    
    private let signUpView = SignUpView()
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = signUpView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.delegate = self
        observeEmailField()
        observePasswordField()
    }
    
    private func observeEmailField() {
        let publisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: signUpView.emailField)
            
        publisher
            .compactMap { ($0.object as? UITextField)?.text }
            .debounce(for: .seconds(1.1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] email in
                self?.handleEmailInputChange(email: email)
            }
            .store(in: &cancellables)
    }
    
    private func observePasswordField() {
        let publisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: signUpView.passwordCheckField)
        
        publisher
            .compactMap { ($0.object as? UITextField)?.text }
            .debounce(for: .seconds(1.1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] password in
                self?.handlePwInput(password: password)
            }
            .store(in: &cancellables)
    }
    
    private func handlePwInput(password: String) {
        if !isEqualPw() {
            signUpView.differentPw()
            return
        }
        let isValid = LoginManager.isValidPassword(password: password)
        signUpView.updateEmailMessage(isValid: isValid)
    }
    
    private func isEqualPw() -> Bool {
        if let pw = signUpView.passwordField.text,
           let pwCheck = signUpView.passwordCheckField.text {
            return pw == pwCheck
        }
        return false
    }

    private func handleEmailInputChange(email: String) {
        Task { @MainActor [weak self] in
            do {
                let result = try await LoginManager.checkEmailStatus(email: email)
                self?.updateUI(for: result)
            } catch {
                self?.showToast(message: "이메일 상태 확인 중 에러 발생")
            }
        }
    }

    private func updateUI(for result: EmailCheckResult) {
        signUpView.showEmailFieldMessage(result: result)
        signUpView.updateVerifyButton(result: result)
    }

}

extension SignUpViewController: SignUpViewDelegate {
    
    func didTapVerifyButton() {
        signUpView.confirmEmail()
    }
    
    func didTapSignUpButton() {
        guard let email = signUpView.emailField.text,
              let pw = signUpView.passwordField.text else {
            return
        }
        Task {
            do {
                let result = try await createUser(email: email, password: pw)
                try await sendEmailVerification(user: result.user)
                try await LoginManager.registerUser(uid: result.user.uid, email: email)
                showEmailVerificationAlert(user: result.user)
                
            } catch {
                showToast(message: "회원가입 실패: \(error.localizedDescription)")
            }
        }
    }

    private func createUser(email: String, password: String) async throws -> AuthDataResult {
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let result {
                    continuation.resume(returning: result)
                } else {
                    let error: Error = error ?? UnknownError()
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func sendEmailVerification(user: User) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            user.sendEmailVerification { error in
                if let error = error { continuation.resume(throwing: error) }
                else { continuation.resume() }
            }
        }
    }
   
    private func showEmailVerificationAlert(user: User) {
        let alert = UIAlertController(
            title: "이메일 인증",
            message: "회원가입이 완료되었습니다!\n이메일을 확인하여 인증을 완료해주세요.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "인증 이메일 재발송", style: .default) { [weak self] _ in
            self?.resendEmailVerification(user: user)
        })
        
        present(alert, animated: true)
    }
    
    private func resendEmailVerification(user: User) {
        Task {
            do {
                try await sendEmailVerification(user: user)
                showToast(message: "인증 이메일이 다시 발송되었습니다.")
            } catch {
                showToast(message: "이메일 재발송 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func isEmailVerified() async -> Bool {
        guard let user = Auth.auth().currentUser else {
            return false
        }
        try? await user.reload()
        return user.isEmailVerified
    }
       
}
