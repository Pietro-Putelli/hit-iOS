//
//  BounceView.swift
//  searchBar
//
//  Created by Pietro Putelli on 27/07/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol BounceViewDelegate: class {
    func touchesEnded(_ bounceView: BounceView)
}

class BounceView: UIView {

    // MARK: - Models
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    lazy var loadingView: NVActivityIndicatorView = {
        let nv = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .white(alpha: 0.6), padding: nil)
        nv.isHidden = true
        return nv
    }()
    
    // MARK: - Proprieties
    
    weak var delegate: BounceViewDelegate?
    
    private let animationDuration: TimeInterval = 0.2
    private let scaleBy: CGFloat = 0.8
    
    var isHighlighted: Bool = false {
        didSet {
            highlight(isHighlighted)
        }
    }
    
    var isEnabled: Bool = false {
        didSet {
            if isEnabled {
                UIView.animate(withDuration: 0.2) {
                    self.alpha = 1
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.alpha = 0.5
                }
            }
        }
    }
    
    var isFeedBackEnabled: Bool = false
    
    init(image: UIImage?, padding: CGFloat = 0, tag: Int = 0) {
        super.init(frame: .zero)
        
        tintColor = .perla
        self.tag = tag
        
        if let image = image {
            imageView.image = image
            addSubviews(imageView,loadingView)
            
            loadingView.fillSuperview(padding: .init(side: padding + 2))
            imageView.fillSuperview(padding: .init(side: padding))
        }
    }
    
    func startLoading() {
        UIView.animate(withDuration: 0.0, animations: {
            self.imageView.hide(true)
        }) { (_) in
            self.loadingView.startAnimating()
            self.loadingView.hide(false)
        }
    }
    
    func stopLoading() {
        loadingView.stopAnimating()
        imageView.hide(false)
        loadingView.hide(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handle touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = true
         DispatchQueue.main.async {
             self.alpha = 1.0
            UIView.animate(withDuration: self.animationDuration, delay: 0.0, options: .curveLinear, animations: {
                 self.alpha = 0.5
             }, completion: nil)
         }
     }

     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        delegate?.touchesEnded(self)
         DispatchQueue.main.async {
            self.alpha = 0.5
            UIView.animate(withDuration: self.animationDuration, delay: 0.0, options: .curveLinear, animations: {
                 self.alpha = 1.0
             }, completion: nil)
         }
        
        if isFeedBackEnabled {
            generateHapticFeedback(for: .light)
        }
     }

     override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
         DispatchQueue.main.async {
             self.alpha = 0.5
            UIView.animate(withDuration: self.animationDuration, delay: 0.0, options: .curveLinear, animations: {
                 self.alpha = 1.0
             }, completion: nil)
         }
     }
    
    func highlight(_ value: Bool) {
        guard !value else {
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: .curveEaseOut, animations: {
                self.transform = self.transform.scaledBy(x: self.scaleBy, y: self.scaleBy)
            }, completion: nil)
            return
        }
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: .curveEaseOut, animations: {
            self.transform = .identity
        }, completion: nil)
    }
}
