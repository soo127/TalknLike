//
//  FollowingFeedCell.swift
//  TalknLike
//
//  Created by 이상수 on 8/13/25.
//

import UIKit

protocol FollowingFeedCellDelegate: AnyObject {
    func didTapLikeButton(_ cell: FollowingFeedCell)
    func didTapCommentButton(_ cell: FollowingFeedCell)
}

final class FollowingFeedCell: UITableViewCell {

    weak var delegate: FollowingFeedCellDelegate?
    private var loadTask: Task<Void, Never>?

    private let profileImage = UIImageView()
    private let nicknameLabel = UILabel()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let contentLabel = UILabel()
    private let likeButton = UIButton()
    private var likeCount: Int = 0
    private let commentButton = UIButton()
    private let buttonsStackView = UIStackView()

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
    
}

extension FollowingFeedCell {
    
    private func setupSubviews() {
        setupProfileImage()
        setupNicknameLabel()
        setupTitleLabel()
        setupDateLabel()
        setupContentLabel()
        setupLikeButton()
        setupCommentButton()
        setupButtonsStackView()
    }
    
    private func setupProfileImage() {
        contentView.addSubview(profileImage)
        profileImage.image = UIImage(systemName: "person.crop.circle")
        profileImage.layer.cornerRadius = 25
        profileImage.clipsToBounds = true
    }
    
    private func setupNicknameLabel() {
        contentView.addSubview(nicknameLabel)
        nicknameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    private func setupDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.textColor = .gray
        dateLabel.font = UIFont.systemFont(ofSize: 12)
    }
    
    private func setupContentLabel() {
        contentView.addSubview(contentLabel)
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    private func setupLikeButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "hand.thumbsup")
        configuration.title = "\(likeCount) Like"
        configuration.imagePadding = 10
        configuration.buttonSize = .small
        configuration.baseForegroundColor = .gray
        likeButton.configuration = configuration
    }
    
    private func setupCommentButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "text.bubble")
        configuration.title = "Comment"
        configuration.imagePadding = 10
        configuration.buttonSize = .small
        commentButton.configuration = configuration
        commentButton.configuration?.baseForegroundColor = .gray
    }
    
    private func setupButtonsStackView() {
        contentView.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(likeButton)
        buttonsStackView.addArrangedSubview(commentButton)
        
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.alignment = .center
        buttonsStackView.spacing = 10
    }
    
    private func setupButtonActions() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
    }
    
}

extension FollowingFeedCell {
    
    private func setupLayout() {
        layoutProfileImage()
        layoutNicknameLabel()
        layoutDateLabel()
        layoutTitleLabel()
        layoutContentLabel()
        layoutButtonsStackView()
    }
    
    private func layoutProfileImage() {
        profileImage.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            padding: UIEdgeInsets(top: 12, left: 10, bottom: 0, right: 0),
            width: 50,
            height: 50
        )
    }
    
    private func layoutNicknameLabel() {
        nicknameLabel.anchor(
            top: profileImage.topAnchor,
            leading: profileImage.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        )
    }
    
    private func layoutDateLabel() {
        dateLabel.anchor(
            top: nicknameLabel.bottomAnchor,
            leading: profileImage.trailingAnchor,
            padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        )
    }
    
    private func layoutTitleLabel() {
        titleLabel.anchor(
            top: profileImage.bottomAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        )
    }
    
    private func layoutContentLabel() {
        contentLabel.anchor(
            top: titleLabel.bottomAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        )
    }
    
    private func layoutButtonsStackView() {
        buttonsStackView.anchor(
            top: contentLabel.bottomAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 10, left: 10, bottom: 12, right: 10)
        )
    }
    
}

extension FollowingFeedCell {
    
    @objc private func likeButtonTapped() {
        delegate?.didTapLikeButton(self)
    }
    
    @objc private func commentButtonTapped() {
        delegate?.didTapCommentButton(self)
    }
    
}

extension FollowingFeedCell {
 
    var isLike: Bool {
        likeButton.isSelected
    }
    
    func toggleLikeState() {
        likeButton.isSelected.toggle()
        likeCount = likeButton.isSelected ? likeCount + 1 : max(0, likeCount - 1)
        updateLikeButtonAppearance()
    }

    func configure(feedItem: FeedItem) {
        nicknameLabel.text = feedItem.profile.nickname

        let post = feedItem.post
        dateLabel.text = post.createdAt.formatted()
        titleLabel.text = post.title
        contentLabel.text = post.content
        
        loadTask?.cancel()
        loadAsyncData(feedItem: feedItem)
    }
    
    private func loadAsyncData(feedItem: FeedItem) {
        loadTask = Task { @MainActor in
            let profileImage = await ImageLoader.shared.loadImage(from: feedItem.profile.photoURL)
            
            var isLiked = false
            if let documentID = feedItem.post.documentID {
                isLiked = (try? await LikeManager.isLiked(postID: documentID)) ?? false
            }
            
            guard !Task.isCancelled else { return }
            
            self.profileImage.image = profileImage
            self.likeCount = feedItem.post.likeCount
            self.likeButton.isSelected = isLiked
            updateLikeButtonAppearance()
        }
    }
    
    private func updateLikeButtonAppearance() {
        var configuration = likeButton.configuration
        configuration?.image = likeButton.isSelected ? UIImage(systemName: "hand.thumbsup.fill") : UIImage(systemName: "hand.thumbsup")
        configuration?.baseForegroundColor = likeButton.isSelected ? .systemBlue : .gray
        configuration?.title = "\(likeCount) Like"
        likeButton.configuration = configuration
    }
    
}
