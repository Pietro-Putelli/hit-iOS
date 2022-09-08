//
//  SettingsCollectionView.swift
//  Hit
//
//  Created by Pietro Putelli on 20/10/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class SettingsCollectionView: UICollectionView {
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
