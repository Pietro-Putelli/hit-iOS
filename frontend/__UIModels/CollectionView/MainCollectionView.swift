//
//  MainCollectionView.swift
//  Hit
//
//  Created by Pietro Putelli on 04/09/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class MainCollectionView: UICollectionView {
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
        contentInset.top = 78
        alwaysBounceVertical = true
        translatesAutoresizingMaskIntoConstraints = false
        
        register(SuggestedUsersCell.self, forCellWithReuseIdentifier: CollectionView.Cells.SuggestedUser)
        register(CommentCell.self, forCellWithReuseIdentifier: CollectionView.Cells.Comment)
        register(ChatCell.self, forCellWithReuseIdentifier: CollectionView.Cells.Chat)
        register(SearchUserCell.self, forCellWithReuseIdentifier: CollectionView.Cells.SearchUser)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
