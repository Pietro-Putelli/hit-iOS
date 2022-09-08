//
//  MaireGradientView.swift
//  Hit
//
//  Created by Pietro Putelli on 02/09/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class MaireGradientView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.addGradient(colors: UIColor.maireGradient, locations: [0.85,1.0], startPoint: .init(x: 0.5, y: 0), endPoint: .init(x: 0.5, y: 1))
    }
}
