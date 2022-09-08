//
//  ProfileHeaderView.swift
//  searchBar
//
//  Created by Pietro Putelli on 02/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate: class {
    func pushFollowerView(_ followType: FollowerType)
    func pushFolloweBy()
    func editProfile()
    func endRefreshing()
}

class ProfileHeaderView: UIView {
    
    // MARK: - Models
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy var profileImageView: ProfileImageView = {
        let imgView = ProfileImageView()
        imgView.isBouncingEnalble = true
        imgView.isOnlineHidden = true
        imgView.isBouncingEnalble = false
        imgView.setupBorder(side: self.profileImageViewSize.width, multiplier: 0.9)
        return imgView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.Main.withSize(26)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.Main.withSize(16)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var imageViewCover: UIView = {
        let v = UIView()
        v.layer.addGradient(size: .init(width: UIScreen.main.bounds.width, height: self.imageViewCoverHeight), colors: [.maire,.clear], locations: [0,1.0], startPoint: .init(x: 0.5, y: 1), endPoint: .init(x: 0.5, y: 0))
        v.alpha = 0.6
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var followersView: FollowerView = {
        let view = FollowerView()
        view.setTitles(count: 0, title: .follower)
        view.tapGesture.addTarget(self, action: #selector(pushFollowersView(_:)))
        return view
    }()
    
    lazy var followingView: FollowerView = {
        let view = FollowerView()
        view.setTitles(count: 0, title: .following)
        view.tapGesture.addTarget(self, action: #selector(pushFollowingView(_:)))
        return view
    }()
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.textColor = .white(alpha: 0.6)
        tv.backgroundColor = .clear
        tv.font = Fonts.Main.withSize(12)
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.textContainerInset = .init(top: 4, left: 0, bottom: 4, right: 0)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var followButton: FollowButton = {
        let button = FollowButton(frame: followButtonFrame)
        button.addTarget(self, action: #selector(handleFollow(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var editProfileButton: MainButton = {
        let button = MainButton(size: self.followButtonFrame.size)
        button.isFill = false
        button.setTitle("Edit Profile", for: .normal)
        button.addTarget(self, action: #selector(editButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var messageButton: MainButton = {
        let button = MainButton(size: self.followButtonFrame.size)
        button.isFill = false
        button.setTitle("Message", for: .normal)
        button.addTarget(self, action: #selector(messageButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var instagramButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white(alpha: 0.8)
        button.imageEdgeInsets = .init(side: 5)
        button.setImage(Images.Instagram, for: .normal)
        button.addTarget(self, action: #selector(instagramButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var linkButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white(alpha: 0.8)
        button.imageEdgeInsets = .init(side: 4)
        button.setImage(Images.SystemIcon.Link, for: .normal)
        button.addTarget(self, action: #selector(linkButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var followedByLabel: FollowedByLabel = {
        let label = FollowedByLabel()
        label.textColor = .white(alpha: 0.6)
        label.font = Fonts.Main.withSize(12)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var followedByTap = UITapGestureRecognizer(target: self, action: #selector(followedBy(_:)))
    
    // MARK: - Proprieties
    
    weak var delegate: ProfileHeaderViewDelegate?
    
    var selectedUser: UserDB?
    
    private var textViewWidth: CGFloat {
        return .screenWidth - 32
    }
    
    var height: CGFloat {
        textView.text = selectedUser!.bio
        var height: CGFloat = (2 / 5) * profileImageViewSize.height + 4
        let textViewHeight = textView.getTextViewHeight(width: textViewWidth, fontSize: 12) + 16
        height += textViewHeight + 4 + followButton.frame.height + 12 + followedByLabel.frame.height + 8
        return height
    }
    
    var myProfileHeight: CGFloat {
        textView.text = User.shared.bio
        var height: CGFloat = (2 / 5) * profileImageViewSize.height + 4
        let textViewHeight = textView.getTextViewHeight(width: textViewWidth, fontSize: 12) + 16
        height += textViewHeight + 4 + followButton.frame.height - 2
        return height
    }
    
    private var imageManager = ImageManager()
    
    var imageViewHeightConstraint: NSLayoutConstraint!
    
    var bottomInset: CGFloat = 0
    
    private let profileImageViewSize: CGSize = .init(side: 100)
    private let followButtonFrame: CGRect = .init(origin: .zero, size: .init(width: 120, height: 34))
    private let messageButtonSize: CGSize = .init(side: 34)
    private let imageViewCoverHeight: CGFloat = 50
    private let cornerRadius: CGFloat = 16
    
    init(selectedUser: UserDB?) {
        super.init(frame: .zero)
        
        self.selectedUser = selectedUser
        
        bottomInset = (selectedUser == nil) ? myProfileHeight : height
        
        setupSubviews()
        addConstraints()
        
        if selectedUser == nil {
            setupMyProfile()
        } else {
            setupUserProfile()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.roundBottomCorners(cornerRadius: cornerRadius)
        roundBottomCorners(cornerRadius: cornerRadius)
    }
    
    // MARK: - Private Setup
    
    private func setupSubviews() {
        
        backgroundColor = .mardiGras
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(imageView, profileImageView, nameLabel, usernameLabel, followersView, followingView, textView, followButton, messageButton, followedByLabel)
        imageView.addSubview(imageViewCover)
        
        followedByLabel.addGestureRecognizer(followedByTap)
    }
    
    private func addConstraints() {
        
        imageView.fillSuperview(padding: .init(top: 0, left: 0, bottom: bottomInset, right: 0))
        profileImageView.anchorWidthHeight(size: profileImageViewSize)
        followButton.anchorWidthHeight(size: followButtonFrame.size)
        
        messageButton.anchorWidthHeight(size: followButtonFrame.size)
        
        NSLayoutConstraint.activate([
            imageViewCover.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            imageViewCover.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            imageViewCover.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            imageViewCover.heightAnchor.constraint(equalToConstant: imageViewCoverHeight),
            
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -profileImageViewSize.height * 0.1),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameLabel.bottomAnchor.constraint(equalTo: usernameLabel.topAnchor, constant: 4),
            
            usernameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 4),
            usernameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            usernameLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -2),
            
            followersView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 8),
            followersView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            
            followingView.leadingAnchor.constraint(equalTo: followersView.trailingAnchor, constant: 16),
            followingView.centerYAnchor.constraint(equalTo: followersView.centerYAnchor),
            
            textView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 4),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            followButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            followButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 4),
            
            messageButton.leadingAnchor.constraint(equalTo: followButton.trailingAnchor, constant: 8),
            messageButton.centerYAnchor.constraint(equalTo: followButton.centerYAnchor),
            
            followedByLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            followedByLabel.topAnchor.constraint(equalTo: followButton.bottomAnchor, constant: 12),
            followedByLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}

// MARK: - Public Setup

extension ProfileHeaderView {
    
    func setupMyProfile() {
        setupEditButton()
        
        let user = User.shared
        setupImage(userId: user.id)
        setupFollowersCount(userId: user.id)
        
        usernameLabel.text = "@\(user.username)"
        usernameLabel.setFirstCharacterColor(UIColor.tagColor)
        nameLabel.text = user.name
    }
    
    func setupUserProfile() {
        guard let user = selectedUser else { return }
        setupImage(userId: user.id)
        setupFollowersCount(userId: user.id)
        setupFollowedByLabel()
        
        usernameLabel.text = "@\(user.username)"
        usernameLabel.setFirstCharacterColor(.purple)
        nameLabel.text = user.name
        followButton.isFollowing = user.followBack
        
        if user.link.notEmpty && user.instagram.notEmpty {
            addInstagramAndLinkButtons()
        } else if user.link.notEmpty && user.instagram.isEmpty {
            addLinkButton()
        } else {
            addInstagramButton()
        }
    }
    
    private func addInstagramButton() {
        addSubview(instagramButton)
        instagramButton.anchorWidthHeight(size: messageButtonSize)
        
        NSLayoutConstraint.activate([
            instagramButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            instagramButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            instagramButton.leadingAnchor.constraint(equalTo: followedByLabel.trailingAnchor, constant: 8)
        ])
    }
    
    private func addLinkButton() {
        addSubview(linkButton)
        linkButton.anchorWidthHeight(size: messageButtonSize)
        
        NSLayoutConstraint.activate([
            linkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            linkButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            linkButton.leadingAnchor.constraint(equalTo: followedByLabel.trailingAnchor, constant: 8)
        ])
    }
    
    private func addInstagramAndLinkButtons() {
        addSubviews(linkButton, instagramButton)
        linkButton.anchorWidthHeight(size: messageButtonSize)
        instagramButton.anchorWidthHeight(size: messageButtonSize)
        
        NSLayoutConstraint.activate([
            linkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            linkButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            instagramButton.trailingAnchor.constraint(equalTo: linkButton.leadingAnchor),
            instagramButton.centerYAnchor.constraint(equalTo: linkButton.centerYAnchor),
            instagramButton.leadingAnchor.constraint(equalTo: followedByLabel.trailingAnchor, constant: 8)
        ])
    }
    
    func setupFollowersCount(userId: Int) {
        Database.User.getFollowersCount(userId: userId) { [weak self] (followers, following) in
            self?.followersView.setTitles(count: followers, title: .follower)
            self?.followingView.setTitles(count: following, title: .following)
        }
    }
    
    func setupImages(image: UIImage?) {
        imageView.image = image
        profileImageView.image = image
    }
    
    func setupImage(userId: Int) {
        imageView.image = nil
        DispatchQueue.global(qos: .background).async {
            guard let image = self.imageManager.retrive(forKey: userId, imageType: .profile) else {
                Database.Image.download(withURL: Php.User.profileImage(userId)) { (image) in
                    self.imageManager.save(image: image, forKey: userId, imageType: .profile)
                    self.imageView.setImage(image: image)
                    self.profileImageView.imageView.setImage(image: image)
                }
                return
            }
            DispatchQueue.main.async {
                self.imageView.setImage(image: image)
                self.profileImageView.imageView.setImage(image: image)
            }
        }
    }
    
    private func setupFollowedByLabel() {
        guard let selectedUser = selectedUser else { return }
        Database.User.getFollowedByTitle(userId: selectedUser.id) { (response) in
            setupTitle(usernames: response.0, counting: response.1)
        }
        
        func setupTitle(usernames: [String], counting: Int) {
            guard counting > 0 else { return }
            var text = "Followed by "
            for username in usernames {
                text += "@\(username), "
            }
            text.removeLast(); text.removeLast()
            if counting - 2 > 0 {
                text += " and \(counting - 2) others"
            }
            followedByLabel.text = text
        }
    }
    
    // MARK: - Secondary functions
    
    private func setupEditButton() {
        messageButton.removeFromSuperview()
        instagramButton.removeFromSuperview()
        linkButton.removeFromSuperview()
        followedByLabel.removeFromSuperview()
        followButton.removeFromSuperview()
        
        addSubview(editProfileButton)
        
        editProfileButton.anchorWidthHeight(size: self.followButtonFrame.size)
        
        NSLayoutConstraint.activate([
            editProfileButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            editProfileButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 4)
        ])
    }
    
    private func openUrl(string: String) {
        guard let url = URL(string: string),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - Objective-C functions

extension ProfileHeaderView {
    
    @objc private func pushFollowersView(_ gesture: UITapGestureRecognizer) {
        followersView.pulse()
        delegate?.pushFollowerView(.follower)
    }
    
    @objc private func pushFollowingView(_ gesture: UITapGestureRecognizer) {
        followingView.pulse()
        delegate?.pushFollowerView(.following)
    }
    
    @objc private func editButtonAction(_ button: UIButton) {
        button.pulse()
        delegate?.editProfile()
    }
    
    @objc private func messageButton(_ button: UIButton) {
        button.pulse()
    }
    
    @objc private func instagramButton(_ button: UIButton) {
        button.pulse()
        
        let instagram = "instagram://user?username=\(selectedUser!.id)"
        openUrl(string: instagram)
    }
    
    @objc private func linkButton(_ button: UIButton) {
        button.pulse()
        
        let link = "https://\(selectedUser!.link)"
        openUrl(string: link)
    }
    
    @objc private func followedBy(_ gesture: UIGestureRecognizer) {
        delegate?.pushFolloweBy()
    }
    
    @objc private func handleFollow(_ button: UIButton) {
        let userId = (selectedUser == nil) ? User.shared.id : selectedUser!.id
        Database.User.handleFollow(followingId: selectedUser!.id, isFollowing: followButton.isFollowing) { (successfull) in
            if successfull {
                self.setupFollowersCount(userId: userId)
            }
        }
    }
}
