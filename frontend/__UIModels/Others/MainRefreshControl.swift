//
//  MainRefreshControl.swift
//  searchBar
//
//  Created by Pietro Putelli on 28/07/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MainRefreshControl: UIRefreshControl {
    
    lazy var activityIndicator: NVActivityIndicatorView = {
        let nv = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .white(alpha: 0.6), padding: nil)
        nv.startAnimating()
        return nv
    }()
    
    override init() {
        super.init(frame: .zero)
        
        tintColor = .clear
        addSubview(activityIndicator)
        
        let x: CGFloat = 24.0
        
        activityIndicator.anchorWidthHeight(size: .init(width: x, height: x))
        activityIndicator.centerSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
