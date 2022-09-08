//
//  NetworkErrorView.swift
//  searchBar
//
//  Created by Pietro Putelli on 14/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class NetworkErrorView: UIView {
    
    // MARK: - Models
    
    lazy var pulseView: NVActivityIndicatorView = {
        let nv = NVActivityIndicatorView(frame: .init(origin: .init(x: 20, y: 20), size: frame.size), type: .ballScale, color: .electricIndigo, padding: nil)
        nv.startAnimating()
        return nv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        layer.zPosition = 10
        addSubviews(pulseView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
