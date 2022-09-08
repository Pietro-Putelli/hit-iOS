//
//  ProfileImageCell.swift
//  searchBar
//
//  Created by Pietro Putelli on 05/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ProfileImageViewCell: UICollectionViewCell {
    
    // MARK: - Models
    
    lazy var profileImageView: ProfileImageView = {
        let imgView = ProfileImageView()
        imgView.isOnlineHidden = true
        imgView.isBouncingEnalble = false
        imgView.imageView.image = User.shared.imageData?.toImage
        imgView.setupBorder(side: profileImageViewSize.width)
        return imgView
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(changeImage(_:)))
        return tap
    }()
    
    lazy var activityIndicator: NVActivityIndicatorView = {
        let nv = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .white(alpha: 0.8), padding: nil)
        return nv
    }()
    
    // MARK: - Proprieties
    
    weak var delegate: EditProfileViewControllerDelegate?
    
    private let profileImageViewSize: CGSize = .init(width: 110, height: 110)
    private let activityIndicatorSize: CGSize = .init(width: 25, height: 25)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.addSubview(activityIndicator)
        profileImageView.addGestureRecognizer(tapGesture)
        
        profileImageView.anchorWidthHeight(size: profileImageViewSize)
        profileImageView.centerSuperview()
        
        activityIndicator.anchorWidthHeight(size: activityIndicatorSize)
        activityIndicator.centerSuperview()
        
        NotificationCenter.default.addObserver(forName: .profileImage, object: nil, queue: .main) { [weak self] (notification) in
            guard let image = notification.userInfo?[notification.name] as? UIImage else { return }
            self?.profileImageView.imageView.image = image
        }
    }
    
    @objc private func changeImage(_ sender: UIGestureRecognizer) {
        profileImageView.pulse(hapticFeedback: true)
        DispatchQueue.main.async {
            self.delegate?.presentImagePicker()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
