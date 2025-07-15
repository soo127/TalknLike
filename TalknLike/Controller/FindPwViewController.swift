//
//  FindPwViewController.swift
//  TalknLike
//
//  Created by 이상수 on 7/15/25.
//

import UIKit

protocol StepView {
    var onNext: (() -> Void)? { get set }
}

final class FindPwViewController: UIViewController {

    private let contentView = UIView()

    private var stepIndex = 0
    private let steps: [UIView & StepView] = [
        IdCheckView(),
        PhoneVerifyView(),
        NewPwView()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        showStep(index: stepIndex)
    }

    private func setupLayout() {
        view.backgroundColor = .white

        let stack = UIStackView(arrangedSubviews: [ contentView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func showStep(index: Int) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        var stepView = steps[index]
        stepView.onNext = { [weak self] in
            self?.goToNextStep()
        }
        contentView.addSubview(stepView)

        stepView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stepView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stepView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stepView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stepView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

    }

    private func goToNextStep() {
        guard stepIndex + 1 < steps.count else {
            completeResetPw()
            return
        }
        stepIndex += 1
        showStep(index: stepIndex)
    }
    
    private func completeResetPw() {
        let alert = UIAlertController(title: "완료!", message: "비밀번호 재설정이 완료되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
}
