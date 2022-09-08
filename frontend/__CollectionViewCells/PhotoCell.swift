//
//  PhotoCell.swift
//  Hit
//
//  Created by Pietro Putelli on 17/10/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit
import Photos

class PhotoCell: UICollectionViewCell {
    
    // MARK: - Models
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    lazy var checkIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.SystemIcon.CheckMarkCircle
        imageView.tintColor = .blueViolet
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var surfaceView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        view.isHidden = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    // MARK: - Proprieties
    
    var representedAssetIdentifier: String!
    
    var image: UIImage! {
        didSet {
            imageView.image = image
        }
    }
    
    var isSelect: Bool = false {
        didSet {
            if isSelect {
                checkIcon.fadeIn()
                surfaceView.fadeIn()
            } else {
                checkIcon.fadeOut()
                surfaceView.fadeOut()
            }
        }
    }
    
    private let checkMarkSize: CGSize = .init(side: 30)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(imageView,surfaceView,checkIcon)
        
        imageView.fillSuperview()
        checkIcon.anchorWidthHeight(size: checkMarkSize)
        surfaceView.fillSuperview()
        
        NSLayoutConstraint.activate([
            checkIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            checkIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pulse(scaleBy: CGFloat = 0.95, animationDuration: TimeInterval = 0.1) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.transform = .init(scaleX: scaleBy, y: scaleBy)
        }) { (_) in
            UIView.animate(withDuration: animationDuration) {
                self.transform = .identity
            }
        }
    }
}
