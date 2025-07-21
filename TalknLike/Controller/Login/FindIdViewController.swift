//
//  FindIdViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/14/25.
//

import UIKit

final class FindIdViewController: UIViewController {

    private let findView = FindIdView()
    
    override func loadView() {
        self.view = findView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTargets()
    }

    private func setupTargets() {
        findView.phoneField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        findView.submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }

    @objc private func textFieldsChanged() {
        let isFilled = !findView.phoneField.text!.isEmpty
        findView.submitButton.isEnabled = isFilled
        findView.submitButton.alpha = isFilled ? 1.0 : 0.5
    }

    @objc private func submitTapped() {
        let alert = UIAlertController(title: "아이디 찾기", message: "해당 기능은 준비 중입니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
}

