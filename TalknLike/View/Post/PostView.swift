//
//  PostView.swift
//  TalknLike
//
//  Created by 이상수 on 7/29/25.
//

import UIKit

final class PostView: UIView, UITextViewDelegate {
    
    private let placeholderLabel = UILabel()
    let profileImageView = UIImageView()
    let editButton = UIButton(type: .system)
    let nicknameLabel = UILabel()
    let textView = UITextView()
    private let separator = UIView()
    
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
        
        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        editButton.setTitle("편집", for: .normal)

        nicknameLabel.font = .boldSystemFont(ofSize: 20)
        nicknameLabel.text = "닉네임"
        
        separator.backgroundColor = .systemGray5
        separator.translatesAutoresizingMaskIntoConstraints = false
        

        let vStackProfileInfo = UIStackView(arrangedSubviews: [nicknameLabel, editButton])
        vStackProfileInfo.axis = .vertical
        vStackProfileInfo.alignment = .leading
        vStackProfileInfo.spacing = 4

        let profileStack = UIStackView(arrangedSubviews: [profileImageView, vStackProfileInfo])
        profileStack.axis = .horizontal
        profileStack.spacing = 12
        
        let mainStack = UIStackView(arrangedSubviews: [profileStack, separator, textView])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStack)
        textView.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            textView.heightAnchor.constraint(equalToConstant: 300),
            
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5)
        ])
    }
    
    // Placeholder
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
}
