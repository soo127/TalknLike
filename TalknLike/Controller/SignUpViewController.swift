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
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = signUpView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.delegate = self
        observeEmailField()
    }
    
    private func observeEmailField() {
        let publisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: signUpView.emailField)
            
        publisher
            .compactMap { ($0.object as? UITextField)?.text }
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] email in
                self?.handleEmailInputChange(email: email)
            }
            .store(in: &cancellables)
    }

    private func handleEmailInputChange(email: String) {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            let result = await self.checkEmailStatus(email: email)
            self.updateUI(for: result)
        }
    }
    
    private func checkEmailStatus(email: String) async -> EmailCheckResult {
        guard !email.isEmpty else { return .empty }
        do {
            return try await db.collection("Users")
                .whereField("email", isEqualTo: email)
                .getDocuments()
                .documents
                .isEmpty ? .available : .duplicate
        } catch {
            print("Firestore 에러: \(error)")
            return .error
        }
    }
    
    private func updateUI(for result: EmailCheckResult) {
        signUpView.showEmailFieldMessage(result: result)
        signUpView.updateVerifyButton(result: result)
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
    
}
