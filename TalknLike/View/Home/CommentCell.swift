//
//  CommentCell.swift
//  TalknLike
//
//  Created by 이상수 on 8/14/25.
//

import UIKit

protocol CommentCellDelegate: AnyObject {
    func didTapReply(_ cell: CommentCell)
    func didTapMenu(_ cell: CommentCell)
}

final class CommentCell: UITableViewCell {
    
    weak var delegate: CommentCellDelegate?
    private var imageLoadTask: Task<Void, Never>?
    
    private let containerView = UIView()
    private let profileImage = UIImageView()
    private let nicknameLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let replyingLabel = UILabel()
    private let commentLabel = UILabel()
    private let dateLabel = UILabel()
    private let replyButton = UIButton(type: .system)
    private let menuButton = UIButton(type: .system)
    
    private lazy var containerLeadingConstraint: NSLayoutConstraint = {
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupSubviews()
        setupButtonActions()
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        imageLoadTask = nil
        profileImage.image = UIImage(systemName: "person.crop.circle")
    }
    
}

extension CommentCell {
    
    private func setupSubviews() {
        setupContainerView()
        setupProfileImage()
        setupNicknameLabel()
        setupArrowImageView()
        setupReplyingLabel()
        setupCommentLabel()
        setupDateLabel()
        setupReplyButton()
        setupMenuButton()
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
    }
    
    private func setupProfileImage() {
        containerView.addSubview(profileImage)
        profileImage.image = UIImage(systemName: "person.circle")
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
    }
    
    private func setupNicknameLabel() {
        containerView.addSubview(nicknameLabel)
        nicknameLabel.font = .boldSystemFont(ofSize: 14)
        nicknameLabel.textColor = .label
    }
    
    private func setupArrowImageView() {
        containerView.addSubview(arrowImageView)
        arrowImageView.image = UIImage(systemName: "arrowtriangle.forward.fill")
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.tintColor = .secondaryLabel
        arrowImageView.isHidden = true
    }
    
    private func setupReplyingLabel() {
        containerView.addSubview(replyingLabel)
        replyingLabel.font = .boldSystemFont(ofSize: 14)
        replyingLabel.textColor = .label
    }
    
    private func setupCommentLabel() {
        containerView.addSubview(commentLabel)
        commentLabel.font = .systemFont(ofSize: 14)
        commentLabel.textColor = .label
        commentLabel.numberOfLines = 0
    }
    
    private func setupDateLabel() {
        containerView.addSubview(dateLabel)
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryLabel
    }
    
    private func setupReplyButton() {
        containerView.addSubview(replyButton)
        replyButton.setTitle("답글", for: .normal)
        replyButton.titleLabel?.font = .systemFont(ofSize: 12)
    }
    
    private func setupMenuButton() {
        containerView.addSubview(menuButton)
        menuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        menuButton.tintColor = .secondaryLabel
    }
    
    private func setupButtonActions() {
        replyButton.addTarget(self, action: #selector(didTapReply), for: .touchUpInside)
        menuButton.addTarget(self, action: #selector(didTapMenu), for: .touchUpInside)
    }
    
}

extension CommentCell {
    
    private func setupLayout() {
        layoutContainerView()
        layoutProfileImage()
        layoutNicknameLabel()
        layoutArrowImageView()
        layoutReplyingLabel()
        layoutCommentLabel()
        layoutDateLabel()
        layoutReplyButton()
        layoutMenuButton()
    }
    
    private func layoutContainerView() {
        containerLeadingConstraint.isActive = true
        containerView.anchor(
            top: contentView.topAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 8)
        )
    }
    
    private func layoutProfileImage() {
        profileImage.anchor(
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            width: 40,
            height: 40
        )
    }
    
    private func layoutNicknameLabel() {
        nicknameLabel.anchor(
            top: containerView.topAnchor,
            leading: profileImage.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        )
    }
    
    private func layoutArrowImageView() {
        arrowImageView.anchor(
            top: containerView.topAnchor,
            leading: nicknameLabel.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0),
            width: 14,
            height: 14
        )
    }
    
    private func layoutReplyingLabel() {
        replyingLabel.anchor(
            top: containerView.topAnchor,
            leading: arrowImageView.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 8)
        )
    }
    
    private func layoutCommentLabel() {
        commentLabel.anchor(
            top: nicknameLabel.bottomAnchor,
            leading: nicknameLabel.leadingAnchor,
            trailing: containerView.trailingAnchor,
            padding: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        )
    }
    
    private func layoutDateLabel() {
        dateLabel.anchor(
            top: commentLabel.bottomAnchor,
            leading: nicknameLabel.leadingAnchor,
            bottom: containerView.bottomAnchor,
            padding: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        )
    }
    
    private func layoutReplyButton() {
        replyButton.anchor(
            top: commentLabel.bottomAnchor,
            leading: dateLabel.trailingAnchor,
            bottom: containerView.bottomAnchor,
            padding: UIEdgeInsets(top: 4, left: 16, bottom: 0, right: 0)
        )
    }
    
    private func layoutMenuButton() {
        menuButton.anchor(
            top: containerView.topAnchor,
            trailing: containerView.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8),
            width: 18,
            height: 18
        )
    }
    
}

extension CommentCell {
    
    @objc private func didTapReply() {
        delegate?.didTapReply(self)
    }
    
    @objc private func didTapMenu() {
        delegate?.didTapMenu(self)
    }
    
}

extension CommentCell {

    func configure(displayComment: CommentDisplayModel) {
        let comment = displayComment.comment
        let profile = displayComment.profile
        let replyNickname = displayComment.replyNickname
        
        nicknameLabel.text = profile.nickname
        arrowImageView.isHidden = replyNickname == nil
        replyingLabel.text = replyNickname
        commentLabel.text = comment.content
        dateLabel.text = comment.createdAt.formatted()
        
        containerLeadingConstraint.constant = comment.parentID != nil ? 40 : 8
        
        imageLoadTask?.cancel()
        imageLoadTask = Task { @MainActor in
            let image = await ImageLoader.shared.loadImage(from: profile.photoURL)
            if !Task.isCancelled {
                profileImage.image = image
            }
        }
    }
    
}
