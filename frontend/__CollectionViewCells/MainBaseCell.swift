//
//  MainBaseCell.swift
//  searchBar
//
//  Created by Pietro Putelli on 27/07/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class MainBaseCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
//            if isHighlighted {
//                UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
//                    self.transform = self.transform.scaledBy(x: self.scaleBy, y: self.scaleBy)
//                }, completion: nil)
//            } else {
//                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
//                    self.transform = .identity
//                }, completion: nil)
//            }
        }
    }
    
    private let scaleBy: CGFloat = 0.98
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        roundCorner(radius: 16)
        layer.masksToBounds = true
//        dropShadow(color: .mardiGras)
    }
}
