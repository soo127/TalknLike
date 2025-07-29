//
//  PostView.swift
//  TalknLike
//
//  Created by 이상수 on 7/29/25.
//

import UIKit

final class PostView: UIView, UITextViewDelegate {
    
    private let placeholderLabel = UILabel()
    let textView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textView.delegate = self
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        placeholderLabel.text = "이 텍스트창이 당신을 기다리고 있어요."
        placeholderLabel.textColor = .placeholderText
        placeholderLabel.font = .systemFont(ofSize: 16)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textView)
        addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(equalToConstant: 300),
            
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5),
        ])
    }
    
    // Placeholder
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
}
