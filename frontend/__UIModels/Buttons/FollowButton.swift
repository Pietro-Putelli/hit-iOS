//
//  FollowButton.swift
//  Hit
//
//  Created by Pietro Putelli on 05/03/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class FollowButton: UIButton {
    
    // MARK: - Proprieties
    
    var followerId: Int = 0
    var size: CGSize!
    
    private let transitionDuration: TimeInterval = 0.4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        size = frame.size
        roundCorner(radius: size.height / 2)
        
        titleLabel?.font = Fonts.NunitoRegular.withSize(14)
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(UIColor.perla.withAlphaComponent(0.8), for: .normal)
        addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        setupUnFollowingTheme()
    }
    
    // MARK: - Functions
    
    func setup(followerId: Int, isFollowing: Bool) {
        //self.userId = User.id
        self.followerId = followerId
        self.isFollowing = isFollowing
    }
    
    func setTheme(for isFollowing: Bool) {
        guard isFollowing else {
            setupUnFollowingTheme()
            return
        }
        setupFollowingTheme()
    }
    
    var isFollowing: Bool = false {
        didSet {
            if isFollowing {
                setupFollowingTheme()
            } else {
                setupUnFollowingTheme()
            }
        }
    }
    
    var isFollowBack: Bool = false {
        didSet {
            if isFollowBack {
                setupFollowBackTheme()
            } else {
                isFollowing = false
            }
        }
    }
    
    func setupFollowingTheme() {
        UIView.transition(with: self, duration: transitionDuration, options: .curveEaseIn, animations: {
             self.setTitle("Following", for: .normal)
        }, completion: nil)
        
        backgroundColor = .mardiGras
        makeBorderPath(forBorderWidth: 1.0, color: .white(alpha: 0.2))
        guard let layer = layer.sublayers?.first, layer is CAGradientLayer else { return }
        layer.removeFromSuperlayer()
    }
    
    func setupUnFollowingTheme() {
        UIView.transition(with: self, duration: transitionDuration, options: .curveEaseOut, animations: {
            self.setTitle("Follow", for: .normal)
        }, completion: nil)

        guard let l = layer.sublayers?.first, !(l is CAGradientLayer) else { return }
        layer.addGradient(size: size, colors: UIColor.purpleGradient)
        removeBorder()
    }
    
    func setupFollowBackTheme() {
        UIView.transition(with: self, duration: transitionDuration, options: .curveEaseOut, animations: {
            self.setTitle("Follow Back", for: .normal)
        }, completion: nil)
        removeBorder()
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        if !isFollowing {
            // follow
        } else {
            // unfollow
        }
        pulse(hapticFeedback: false, scaleBy: 0.95)
        
        isFollowing = !isFollowing
        if !isFollowing && isFollowBack {
            setupFollowBackTheme()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

