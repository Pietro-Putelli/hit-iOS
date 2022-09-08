//
//  MessageCell.swift
//  Hit
//
//  Created by Pietro Putelli on 04/09/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class ChatCell: MainBaseCell {
    
    // MARK: - Models
    
    lazy var profileImageView: ProfileImageView = {
       let imageView = ProfileImageView()
        imageView.imageView.image = Images.Steve
        imageView.isBouncingEnalble = false
        imageView.setupBorder(side: profileImageViewSize.width)
        return imageView
    }()
    
    let nameLabel = MainLabel(text: nil, textColor: .white(alpha: 0.8), fontSize: 18, font: Fonts.NunitoRegular)
    let lastMessageLabel = MainLabel(text: nil, textColor: .white(alpha: 0.4), fontSize: 14)
    let rightChevron = ChevronView(type: .right, color: .white(alpha: 0.6))
    
    // MARK: - Proprieties
    
    var profileImageViewSize: CGSize {
        return .init(side: frame.height - 16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        setupSubviews()
        addConstraints()
    }
    
    private func setupSubviews() {
        addSubviews(profileImageView,nameLabel,lastMessageLabel,rightChevron)
        backgroundColor = .mardiGras
    }
    
    private func addConstraints() {
        profileImageView.anchorWidthHeight(size: profileImageViewSize)
        rightChevron.anchorWidthHeight(size: rightChevron.smallSize)
        
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: rightChevron.leadingAnchor, constant: 8),
            
            lastMessageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 2),
            lastMessageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10),
            lastMessageLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            rightChevron.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightChevron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
    
    func setup(chat: Chat) {
        nameLabel.text = chat.username
        profileImageView.setupImage(userId: chat.receiverId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
