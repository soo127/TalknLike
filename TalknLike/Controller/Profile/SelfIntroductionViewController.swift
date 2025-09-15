//
//  SelfIntroductionViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/25/25.
//

import UIKit

import UIKit

final class SelfIntroductionViewController: UIViewController {

    private let selfIntroductionView = SelfIntroductionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupIntroView()
        layoutIntroView()
        setupNavigationBar()
        selfIntroductionView.delegate = self
    }

    private func setupIntroView() {
        view.addSubview(selfIntroductionView)
    }
    
    private func layoutIntroView() {
        selfIntroductionView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor
        )
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "자기소개"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(didTapCancel)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .done,
            target: self,
            action: #selector(didTapSave)
        )
    }
    
    @objc private func didTapCancel() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapSave() {
        let bio = selfIntroductionView.textView.text
        do {
            try CurrentUserStore.shared.update(bio: bio)
        } catch {
            showToast(message: "업데이트 실패")
        }
        navigationController?.popViewController(animated: true)
    }
    
}

extension SelfIntroductionViewController: SelfIntroductionViewDelegate {
    
    func textDidChange(_ text: String) {
        selfIntroductionView.update(text: text)
    }
    
    func shouldChangeText(currentText: String, range: NSRange, text: String) -> Bool {
        if text == "\n" {
            let newlineCount = currentText.components(separatedBy: "\n").count - 1
            if newlineCount >= 1 {
                return false
            }
        }
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let newText = currentText.replacingCharacters(in: stringRange, with: text)
        return newText.count <= selfIntroductionView.maxCount
    }
    
}

