//
//  FavouriteButton.swift
//  searchBar
//
//  Created by Pietro Putelli on 30/07/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class FavouriteButton: UIButton {
    
    // MARK: - Proprieties
    
    private let transitionDuration: TimeInterval = 0.4
    private let transitionOptions: UIView.AnimationOptions = .curveEaseInOut
    
    var commentId: Int!
    
    var isFavourite: Bool = false {
        didSet {
            if isFavourite {
                setFav()
            } else {
                setUnFav()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = .white
        imageEdgeInsets = .init(horizontal: 4, vertical: 1.8)
        addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        setUnFav()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setFav() {
        UIView.transition(with: self, duration: transitionDuration, options: transitionOptions, animations: {
            self.setImage(Images.BookMark.Fill, for: .normal)
        }, completion: nil)
    }
    
    private func setUnFav() {
        UIView.transition(with: self, duration: transitionDuration, options: transitionOptions, animations: {
            self.setImage(Images.BookMark.Empty, for: .normal)
        }, completion: nil)
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        pulse(hapticFeedback: false, scaleBy: 0.90)
        isFavourite = !isFavourite
        
        Database.CommentDb.setCommentFavourite(commentId: commentId, favorited: isFavourite) { (successfull) in
            print(successfull)
        }
    }
}

