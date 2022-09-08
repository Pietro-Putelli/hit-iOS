//
//  ProfilePictureView.swift
//  chat
//
//  Created by Pietro Putelli on 28/05/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ProfileImageView: UIView {
    
    // MARK: - Models
    
    var imageBorderView = UIView()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let borderCircle: UIView = {
        let borderCircle = UIView()
        borderCircle.backgroundColor = .clear
        borderCircle.translatesAutoresizingMaskIntoConstraints = false
        return borderCircle
    }()
    
    let littleCircle: UIView = {
        let littleCircle = UIView()
        littleCircle.translatesAutoresizingMaskIntoConstraints = false
        littleCircle.backgroundColor = .limeGreen
        littleCircle.layer.borderWidth = 2
        littleCircle.layer.borderColor = UIColor.mardiGras.cgColor
        return littleCircle
    }()

    lazy var pulseTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(pulseAction(_:)))
        return tap
    }()
    
    lazy var activityIndicator: NVActivityIndicatorView = {
       let activityIndicator = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .perlaAlpha05, padding: nil)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - Proprieties
    
    var isOnlineHidden: Bool = true {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.littleCircle.isHidden = self.isOnlineHidden
            }
        }
    }
    
    var roundedRadius: CGFloat = 0 {
        didSet {
            layoutSubviews()
        }
    }
    
    var isBouncingEnalble: Bool = false {
        didSet {
            pulseTap.isEnabled = isBouncingEnalble
        }
    }
    
    var image: UIImage? {
        didSet {
            imageView.setImage(image: image)
        }
    }
    
    private var imageManager = ImageManager()
    private var imageViewMultiplier: CGFloat = 0.85
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Setup functions
    
    private func setupSubviews() {
        backgroundColor = .clear
        isUserInteractionEnabled = true

        addSubviews(imageBorderView,imageView,borderCircle,littleCircle,activityIndicator)
        addGestureRecognizer(pulseTap)
    }
    
    func setupBorder(side: CGFloat, lineWidth: CGFloat = 1.4, multiplier: CGFloat = 0.85) {
        imageBorderView.layer.addBorder(bounds: .init(origin: .zero, size: .init(width: side, height: side)), lineWidth: lineWidth, gradientColors: UIColor.purpleGradient)
        imageViewMultiplier = multiplier
        roundedRadius = side / 2
        
        addConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageBorderView.roundCorner(radius: roundedRadius)
        imageView.roundCorner(radius: roundedRadius * imageViewMultiplier)
        borderCircle.layoutIfNeeded()
        borderCircle.roundCorner(radius: roundedRadius * imageViewMultiplier * 0.5)
        littleCircle.layoutIfNeeded()
        littleCircle.roundCorner(radius: roundedRadius * imageViewMultiplier * 0.5 * 0.55)
    }
    
    private func addConstraints() {
        let (hMult, vMult) = computeMultipliers(angle: -45)
        
        NSLayoutConstraint(item: borderCircle, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: hMult, constant: -2).isActive = true
        NSLayoutConstraint(item: borderCircle, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: vMult, constant: -2).isActive = true
        
        imageBorderView.fillSuperview()
        activityIndicator.centerSuperview()
        
        NSLayoutConstraint.activate([
            
            imageView.widthAnchor.constraint(equalTo: imageBorderView.widthAnchor, multiplier: imageViewMultiplier),
            imageView.heightAnchor.constraint(equalTo: imageBorderView.heightAnchor, multiplier: imageViewMultiplier),
            imageView.centerXAnchor.constraint(equalTo: imageBorderView.centerXAnchor, constant: 0),
            imageView.centerYAnchor.constraint(equalTo: imageBorderView.centerYAnchor, constant: 0),
            
            borderCircle.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/2),
            borderCircle.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1/2),
            
            littleCircle.widthAnchor.constraint(equalTo: borderCircle.widthAnchor, multiplier: 1/1.8),
            littleCircle.heightAnchor.constraint(equalTo: borderCircle.heightAnchor, multiplier: 1/1.8),

            littleCircle.centerXAnchor.constraint(equalTo: borderCircle.centerXAnchor),
            littleCircle.centerYAnchor.constraint(equalTo: borderCircle.centerYAnchor),
            
            activityIndicator.widthAnchor.constraint(equalTo: imageBorderView.widthAnchor, multiplier: 0.25),
            activityIndicator.heightAnchor.constraint(equalTo: imageBorderView.heightAnchor, multiplier: 0.25)
        ])
    }
    
    func setupImage(userId: Int) {
        DispatchQueue.global(qos: .background).async {
            guard let image = self.imageManager.retrive(forKey: userId, imageType: .profile) else {
                Database.Image.download(withURL: Php.User.profileImage(userId)) { (image) in
                    self.imageManager.save(image: image, forKey: userId, imageType: .profile)
                    self.imageView.setImage(image: image)
                }
                return
            }
            DispatchQueue.main.async {
                self.imageView.setImage(image: image)
            }
        }
    }
    
    func stopActivityIndicator(_ stopped: Bool) {
        if stopped {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }

    private func computeMultipliers(angle: CGFloat) -> (CGFloat, CGFloat) {
        let radians = angle * .pi / 180

        let h = (1.0 + cos(radians)) / 2
        let v = (1.0 - sin(radians)) / 2

        return (h, v)
    }
    
    @objc private func pulseAction(_ sender: UITapGestureRecognizer) {
        pulse(hapticFeedback: false, scaleBy: 0.98)
    }
}
