//
//  FullScreenNavigationBar.swift
//  searchBar
//
//  Created by Pietro Putelli on 06/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class FullScreenNavigationBar: UIView {
    
    // MARK: - Models
    
    enum NavigationType {
        case navigation
        case profile
        case settings
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white(alpha: 0.6)
        label.font = Fonts.Main.withSize(20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var leftButton: BounceView = {
        let view = BounceView(image: Images.SystemIcon.Chevrons.Left, padding: topButtonPadding)
        view.tintColor = .white(alpha: 0.8)
        view.tag = 1
        return view
    }()
    
    lazy var rightButton: BounceView = {
        let view = BounceView(image: Images.SystemIcon.CheckMark, padding: topButtonPadding)
        view.tintColor = .white(alpha: 0.8)
        return view
    }()
    
    lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.layer.zPosition = rightButton.layer.zPosition - 1
        return view
    }()
    
    lazy var bottomLine: UIView = {
       let view = UIView()
        view.backgroundColor = .white(alpha: 0.2)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Proprieties
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var delegate: BounceViewDelegate? {
        didSet {
            leftButton.delegate = delegate
            rightButton.delegate = delegate
        }
    }
    
    var dismissImage: UIImage? {
        didSet {
            leftButton.imageView.image = dismissImage
        }
    }
    
    var isDoneButtonEnabled: Bool = false {
        didSet {
            rightButton.isEnabled = isDoneButtonEnabled
            rightButton.isUserInteractionEnabled = isDoneButtonEnabled
        }
    }
    
    var titleLabelAlpha: CGFloat = 0 {
        didSet {
            titleLabel.alpha = titleLabelAlpha
        }
    }
    
    var navigationBarHeight: CGFloat {
        return UIViewController().windowSafeAreaInsets.top + 44
    }
    
    private var leftLeadingConstraint: NSLayoutConstraint!
    
    private let topButtonSize: CGSize = .init(width: 40, height: 40)
    private let topButtonPadding: CGFloat = 8
    private let cornerRadius: CGFloat = 12
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(leftButton, titleLabel, rightButton)
        addConstraints()
    }
    
    func setup(_ navigationType: NavigationType, user: UserDB? = nil, chevron: ChevronView.ChevronType = .left) {
        switch navigationType {
        case .navigation:
            rightButton.isHidden = true
            backgroundColor = .maire
            dismissImage = Images.SystemIcon.Chevrons.Left
            roundBottomCorners(cornerRadius: cornerRadius)
        case .profile:
            backgroundColor = .clear
            addSubview(visualEffectView)
            visualEffectView.fillSuperview()
            visualEffectView.roundCorner(radius: cornerRadius)
            
            guard let user = user else {
                title = User.shared.username
                rightButton.imageView.image = Images.Gear
                leftButton.isHidden = true
                return
            }
            leftButton.imageView.image = Images.SystemIcon.Chevrons.Left
            rightButton.imageView.image = Images.SystemIcon.More
            title = user.username
        case .settings:
            leftLeadingConstraint.constant = 16
            if chevron == .down {
                leftButton.imageView.image = Images.SystemIcon.Chevrons.Down
            }
            break
        }
    }
    
    private func addConstraints() {
        leftButton.anchorWidthHeight(size: topButtonSize)
        rightButton.anchorWidthHeight(size: topButtonSize)
        
        leftLeadingConstraint = leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: navigationBarHeight),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            leftLeadingConstraint,
            leftButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rightButton.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
