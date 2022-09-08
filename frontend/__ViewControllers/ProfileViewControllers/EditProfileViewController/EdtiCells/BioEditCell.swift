//
//  BioEditCell.swift
//  searchBar
//
//  Created by Pietro Putelli on 06/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class BioEditCell: MainEditCell {
    
    // MARK: - Models
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.textContainerInset = .zero
        tv.backgroundColor = .clear
        tv.textContainer.maximumNumberOfLines = 3
        tv.textContainer.lineBreakMode = .byTruncatingTail
        tv.isEditable = false
        tv.isSelectable = false
        tv.isUserInteractionEnabled = true
        tv.textColor = .white(alpha: 0.8)
        tv.font = Fonts.Main.withSize(14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let rightChevron = ChevronView(type: .right, color: .white(alpha: 0.6))
    
    // MARK: - Proprieties
    
    private let rightChevronSize: CGSize = .init(width: 14, height: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(textView, rightChevron)
        addConstraints()
    }
    
    // MARK: - Setup
    
    func setup(textViewText: String?) {
        textView.text = textViewText
        titleLabel.text = "BIO"
    }
    
    private func addConstraints() {
        rightChevron.anchorWidthHeight(size: rightChevronSize)
        
        NSLayoutConstraint.activate([
            
            rightChevron.trailingAnchor.constraint(equalTo: bottomLine.trailingAnchor, constant: -2),
            rightChevron.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            textView.leadingAnchor.constraint(equalTo: bottomLine.leadingAnchor, constant: 2),
            textView.trailingAnchor.constraint(equalTo: bottomLine.trailingAnchor, constant: -2),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
