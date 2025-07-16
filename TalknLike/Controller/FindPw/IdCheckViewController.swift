//
//  IdCheckViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/16/25.
//

import UIKit

final class IdCheckViewController: UIViewController {
    
    private let idCheckView = IdCheckView()

    override func loadView() {
        view = idCheckView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        idCheckView.nextButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    @objc func tapped() {
        navigationController?.pushViewController(VerifyViewController(), animated: true)
    }
    
}
