//
//  PostButton.swift
//  Hit
//
//  Created by Pietro Putelli on 30/10/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PostButton: UIButton {
    
    lazy var spinner: NVActivityIndicatorView = {
        let spinner = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .perla, padding: 0)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override var isEnabled: Bool {
        didSet {
            let alpha: CGFloat = !isEnabled ? 0.5 : 1
            UIView.animate(withDuration: 0.2) {
                self.alpha = alpha
            }
        }
    }
    
    var isSpinnerLoading: Bool = false {
        didSet {
            let title = isSpinnerLoading ? "" : "Post".uppercased()
            setTitle(title, for: .normal)
            isEnabled = false
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        setTitleColor(.perla, for: .normal)
        setTitle("Post".uppercased(), for: .normal)
        setFont(for: Fonts.Main.withSize(14))
        addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        alpha = 0.5
        isEnabled = false
        
        addSubview(spinner)
    }
    
    @objc private func buttonDidTap(_ button: UIButton) {
        isSpinnerLoading = true
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.addGradient(size: bounds.size, colors: UIColor.purpleGradient)
        roundCorner()
        
        spinner.anchorWidthHeight(size: .init(side: bounds.height - 16))
        spinner.centerSuperview()
    }
}

