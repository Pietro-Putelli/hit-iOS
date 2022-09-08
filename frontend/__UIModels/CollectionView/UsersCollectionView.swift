//
//  UsersCollectionView.swift
//  searchBar
//
//  Created by Pietro Putelli on 05/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class UsersCollectionView: UICollectionView {
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        register(UserCell.self, forCellWithReuseIdentifier: "cell")
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
