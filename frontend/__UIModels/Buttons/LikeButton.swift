//
//  LikeButton.swift
//  Hit
//
//  Created by Pietro Putelli on 05/03/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class LikeButton: UIButton {
    
    // MARK: - Proprieties
    
    var commentId: Int = 0
    
    private let transitionDuration: TimeInterval = 0.4
    private let transitionOptions: UIView.AnimationOptions = .curveEaseInOut
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = .perla
        
        addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        setUnlike()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Setup functions
    
    func setup(commentId: Int, isLiked: Bool) {
        //self.userId = User.id
        self.commentId = commentId
        self.isLiked = false
    }
    
    func setTheme() {
        guard isLiked else {
            setUnlike()
            return
        }
        setLike()
    }
    
    var isLiked: Bool = false {
        didSet {
            if isLiked {
                setLike()
            } else {
                setUnlike()
            }
        }
    }

    @objc func buttonAction(_ sender: UIButton) {
        pulse(hapticFeedback: true, scaleBy: 0.90)
        isLiked = !isLiked
        
        Database.CommentDb.setCommentLike(commentId: commentId, liked: isLiked) { (successfull) in
            
        }
    }
    
    func setLike() {
        let image = UIImage(named: "heart.fill")?.addGradient(colors: UIColor.redGradient)
        UIView.transition(with: self, duration: transitionDuration, options: transitionOptions, animations: {
            self.setBackgroundImage(image, for: .normal)
        }, completion: nil)
    }
    
    func setUnlike() {
        let image = UIImage(named: "heart.empty")?.withRenderingMode(.alwaysTemplate)
        UIView.transition(with: self, duration: transitionDuration, options: transitionOptions, animations: {
            self.setBackgroundImage(image, for: .normal)
        }, completion: nil)
    }
}
