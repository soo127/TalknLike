//
//  PwResetViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/16/25.
//

import UIKit

final class PwResetViewController: UIViewController {
    
    private let newPwView = NewPwView()

    override func loadView() {
        view = newPwView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newPwView.finishButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    @objc func tapped() {
        let alert = UIAlertController(title: "완료", message: "비밀번호가 재설정되었습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.setViewControllers([LoginViewController()], animated: true)
        }))
        present(alert, animated: true)
    }
    
}
