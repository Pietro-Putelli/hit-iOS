//
//  RubberView.swift
//  RubberView
//
//  Created by Pietro Putelli on 08/06/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

@objc protocol RubberViewDelegate: class {
    func didEndScrolling(_ panGesture: UIPanGestureRecognizer)
    @objc optional func didBeginScrolling(_ panGesture: UIPanGestureRecognizer)
    @objc optional func viewDidDisappear()
}

class RubberView: UIView {
    
    var panGesture: UIPanGestureRecognizer!
    
    var originalFrame: CGRect! {
        didSet {
            frame = originalFrame
        }
    }
    
    weak var delegate: RubberViewDelegate?
    
    let animationDuration: TimeInterval = 0.2
    let topLimit: CGFloat = 34
    
    var yLimit: CGFloat!
    
    var scrollToDismissLimit: CGFloat {
        return 0.2 * frame.height
    }
    
    lazy var cursorView: UIView = {
        let cursor = UIView(frame: CGRect(origin: .init(x: center.x - frame.width / 12, y: 6), size: CGSize(width: frame.width / 6, height: 4)))
        cursor.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        cursor.roundCorner(radius: cursor.frame.height / 2)
        return cursor
    }()
    
    init(frame: CGRect, yLimit: CGFloat) {
        super.init(frame: frame)
        self.yLimit = yLimit
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        originalFrame = frame
        
        roundCorners2(corners: [.topRight,.topLeft], radius: 20)
        backgroundColor = .clear
        
        addSubview(cursorView)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        addGestureRecognizer(panGesture)
    }
    
    @objc private func panAction(_ sender: UIPanGestureRecognizer) {
        guard frame.origin.y > topLimit else {
            guard sender.state == .ended else { return }
            UIView.animate(withDuration: animationDuration) {
                self.frame = self.originalFrame
            }
            return
        }
        
        if sender.state != .ended {
            let yTranslation = sender.translation(in: self).y
            let velocity = sender.velocity(in: self)
            
            guard yTranslation != 0 else { return }
            let translation = 1 + log10(abs(frame.origin.y / yTranslation))
            
            if velocity.y < 0 && frame.origin.y <= originalFrame.origin.y && translation > 0 {
                frame.origin.y -= translation
            } else if (velocity.y < 0 && frame.origin.y > originalFrame.origin.y) || (velocity.y > 0 && frame.origin.y >= originalFrame.origin.y) {
                frame.origin.y = frame.minY + yTranslation
                sender.setTranslation(.zero, in: self)
            }
        } else {
            if frame.origin.y > scrollToDismissLimit {
                dismiss()
            } else {
                UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
                    self.frame = self.originalFrame
                }, completion: nil)
            }
            delegate?.didEndScrolling(panGesture)
        }
        
        if sender.state == .changed {
            delegate?.didBeginScrolling?(panGesture)
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: animationDuration) {
            self.frame.origin.y = self.frame.height
            self.delegate?.viewDidDisappear?()
        }
    }
}

