//
//  UserCell.swift
//  searchBar
//
//  Created by Pietro Putelli on 05/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class UserCell: MainBaseCell {
    
    // MARK: - Models
    
    lazy var profileImageView: ProfileImageView = {
        let imgView = ProfileImageView()
        imgView.isOnlineHidden = false
        imgView.isBouncingEnalble = false
        imgView.setupBorder(side: profileImageViewSize.width)
        return imgView
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Main.withSize(18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var followButton: FollowButton = {
       let button = FollowButton(frame: followButtonFrame)
        button.addTarget(self, action: #selector(handleFollow(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Proprieties
    
    var user: UserDB?
    
    private let followButtonFrame: CGRect = .init(origin: .zero, size: .init(width: 100, height: 28))
    private lazy var profileImageViewSize: CGSize = .init(width: frame.height - 20, height: frame.height - 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        addConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        followButton.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setup(user: UserDB) {
        self.user = user
        usernameLabel.text = user.name
        profileImageView.setupImage(userId: user.id)
        
        guard user.id != User.shared.id else {
            followButton.isHidden = true
            return
        }
        followButton.isFollowing = user.followBack
    }
    
    private func setup() {
        addSubviews(profileImageView,usernameLabel,followButton)
        
        roundCorner(radius: 24)
        backgroundColor = .maire
    }
    
    private func addConstraints() {
        profileImageView.anchorWidthHeight(size: profileImageViewSize)
        followButton.anchorWidthHeight(size: followButtonFrame.size)
        
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: followButtonFrame.size.width + 32),
            
            followButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            followButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc private func handleFollow(_ button: UIButton) {
        Database.User.handleFollow(followingId: user!.id, isFollowing: followButton.isFollowing) { (sucessfull) in
        }
    }
}


