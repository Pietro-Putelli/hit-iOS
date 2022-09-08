//
//  SuggestedUserCell.swift
//  searchBar
//
//  Created by Pietro Putelli on 27/07/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class SuggestedUserCell: MainBaseCell {
    
    // MARK: - Models
    
    lazy var profileImageView: ProfileImageView = {
        let imgView = ProfileImageView()
        imgView.isOnlineHidden = true
        imgView.isBouncingEnalble = false
        imgView.setupBorder(side: self.profileImageViewSide)
        return imgView
    }()
    
    lazy var usernameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .perla
        label.text = "Leonardo Di Caprio"
        label.textAlignment = .center
        label.font = Fonts.Main.withSize(16)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var followButton: FollowButton = {
        let button = FollowButton(frame: .init(origin: .zero, size: followButtonSize))
        button.addTarget(self, action: #selector(handleFollow(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Proprieties
    
    var user: UserDB?
    
    private let profileImageViewSide: CGFloat = 50
    private lazy var followButtonSize: CGSize = .init(width: frame.width - 16, height: 32)
    
    override func prepareForReuse() {
        followButton.isFollowBack = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .mardiGras
        
        addSubviews(profileImageView, followButton, usernameLabel)
        
        addConstraints()
    }
    
    // MARK: - Setup functions
    
    func setup(user: UserDB) {
        self.user = user
        usernameLabel.text = user.name
        followButton.isFollowBack = user.followBack
        profileImageView.setupImage(userId: user.id)
    }
    
    private func addConstraints() {
        profileImageView.anchorWidthHeight(size: .init(width: profileImageViewSide, height: profileImageViewSide))
        followButton.anchorWidthHeight(size: followButtonSize)

        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            followButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            followButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            usernameLabel.bottomAnchor.constraint(equalTo: followButton.topAnchor, constant: -12),
            usernameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    @objc private func handleFollow(_ button: UIButton) {
        Database.User.handleFollow(followingId: user!.id, isFollowing: followButton.isFollowing) { (successfull) in
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
