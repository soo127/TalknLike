//
//  UIViewController+Extension.swift
//  TalknLike
//
//  Created by 이상수 on 8/4/25.
//

import UIKit

extension UIViewController {
    
    func showToast(message: String) {
        let toastLabel = setupToastLabel(message: message)
        let maxWidth = view.frame.width - 40
        let textSize = toastLabel.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        
        toastLabel.frame = CGRect(
            x: (view.frame.width - textSize.width - 20) / 2,
            y: view.frame.height - textSize.height - 120,
            width: textSize.width + 20,
            height: textSize.height + 12
        )
        
        view.addSubview(toastLabel)
        UIView.animate(
            withDuration: 0.3,
            delay: 1,
            options: .curveEaseOut,
            animations: {
                toastLabel.alpha = 0.0
            }
        ) {  _ in
            toastLabel.removeFromSuperview()
        }
    }
    
    private func setupToastLabel(message: String) -> UILabel {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.font = .systemFont(ofSize: 14)
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textAlignment = .center
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        return toastLabel
    }
    
}
