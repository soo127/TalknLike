//
//  VerifyViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/16/25.
//

import UIKit

final class VerifyViewController: UIViewController {
    
    private let verifyView = PhoneVerifyView()

    override func loadView() {
        view = verifyView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        verifyView.nextButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    @objc private func tapped() {
        navigationController?.pushViewController(PwResetViewController(), animated: true)
    }
    
}
