//
//  ProfileNavigationView.swift
//  Hit
//
//  Created by Pietro Putelli on 29/03/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class MainNavigationBar: UIView {
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Models
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Main.withSize(20)
        label.textColor = .white(alpha: 0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.imageEdgeInsets = .init(side: 4)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0
        visualEffectView.clipsToBounds = true
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()
    
    // MARK: - Proprieties
    
    var screenBounds: CGRect {
        return UIScreen.main.bounds
    }
    
    var title: String? {
        didSet {
            usernameLabel.text = title
        }
    }
    
    var titleLabelAlpha: CGFloat = 0 {
        didSet {
            usernameLabel.alpha = titleLabelAlpha
        }
    }
    
    var leftButtonImage: UIImage? {
        didSet {
            leftButton.setImage(leftButtonImage, for: .normal)
        }
    }
    
    var rightButtonImage: UIImage? {
        didSet {
            rightButton.setImage(rightButtonImage, for: .normal)
        }
    }
    
    var isVisualEffectViewHidden: Bool = false {
        didSet {
            visualEffectView.isHidden = isVisualEffectViewHidden
        }
    }
    
    var usernameLabelBottomConstant: CGFloat = 0 {
        didSet {
            usernameBottomConstraint.constant -= usernameLabelBottomConstant
        }
    }
    
    private let buttonSize: CGSize = .init(side: 40)
    
    private var usernameBottomConstraint: NSLayoutConstraint!
    
    init() {
        super.init(frame: .zero)
        
        setupSubviews()
        addConstraints()
    }
    
    // MARK: - Setup
    
    func setupSubviews() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(visualEffectView,usernameLabel,rightButton,leftButton)
    }
    
    private func addConstraints() {
        addVisualEffectViewConstraints()
        
        NSLayoutConstraint.anchorWidthHeight(size: buttonSize, [
            rightButton, leftButton
        ])
        
        usernameBottomConstraint = usernameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        
        NSLayoutConstraint.activate([
            usernameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            usernameBottomConstraint,
            
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            rightButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            leftButton.centerYAnchor.constraint(equalTo: rightButton.centerYAnchor)
        ])
    }
    
    private func addVisualEffectViewConstraints() {
        
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: topAnchor),
            visualEffectView.rightAnchor.constraint(equalTo: rightAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            visualEffectView.leftAnchor.constraint(equalTo: leftAnchor)
        ])
    }
}
