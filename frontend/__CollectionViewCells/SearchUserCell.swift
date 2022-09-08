//
//  UserCell.swift
//  searchCollectionView
//
//  Created by Pietro Putelli on 24/07/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class SearchUserCell: MainBaseCell {
    
    // MARK: - Models
    
    lazy var profileImageView: ProfileImageView = {
        let imageView = ProfileImageView()
        imageView.roundedRadius = profileImageViewSide / 2
        imageView.isBouncingEnalble = false
        imageView.isOnlineHidden = true
        imageView.setupBorder(side: self.profileImageViewSide)
        return imageView
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.SystemIcon.XMark, for: .normal)
        button.tintColor = .white(alpha: 0.8)
        button.isHidden = true
        button.addTarget(self, action: #selector(deleteButton(_:)), for: .touchUpInside)
        return button
    }()
    
    let usernameLabel = MainLabel(textColor: .white(alpha: 0.6), fontSize: 0)
    let rightChevron = ChevronView(type: .right, color: .white(alpha: 0.4))
    
    // MARK: - Proprieties
    
    var userId: Int!
    
    var deleteButtonHidden: Bool = true {
        didSet {
            deleteButton.isHidden = deleteButtonHidden
            rightChevron.isHidden = !deleteButton.isHidden
        }
    }
    
    private var profileImageViewSide: CGFloat {
        return frame.height - 16
    }
    
    private let deleteButtonSize = CGSize(side: 18)
        
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.imageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupSubviews() {
        backgroundColor = .mardiGras
        
        addSubviews(profileImageView, usernameLabel, deleteButton, rightChevron)
    }
    
    func setup(user: UserDB, fontSize: CGFloat = 18) {
        self.userId = user.id
        
        usernameLabel.fontSize(fontSize)
        usernameLabel.text = user.username
        profileImageView.setupImage(userId: user.id)
    }
    
    private func addConstraints() {
        profileImageView.anchorWidthHeight(size: .init(side: profileImageViewSide))
        deleteButton.anchorWidthHeight(size: deleteButtonSize)
        rightChevron.anchorWidthHeight(size: rightChevron.smallSize)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor),
            
            rightChevron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            rightChevron.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Objective functions
    
    @objc private func deleteButton(_ button: UIButton) {
        button.pulse()
        RecentSearchManager().removeUser(userId)
        NotificationCenter.default.post(name: .refreshRecentSearch, object: nil, userInfo: nil)
    }
}
