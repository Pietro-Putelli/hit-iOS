//
//  FollowedByLabel.swift
//  Hit
//
//  Created by Pietro Putelli on 01/11/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class FollowedByLabel: UILabel {
    
    override var text: String? {
        didSet {
            attributedText = attributedNumberString(string: text ?? "")
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func findNumberRanges(string: String) -> [NSRange]{
        let nsString = string as NSString
        let regex = try? NSRegularExpression(pattern: "@", options: [])
        let matches = regex?.matches(in: string, options: .withoutAnchoringBounds, range: NSMakeRange(0, nsString.length))
        return matches?.map{$0.range} ?? []
    }
    
    private func attributedNumberString(string: String) -> NSAttributedString {
        let ranges = findNumberRanges(string: string)

        let attributedString = NSMutableAttributedString(string: string)
        for range in ranges {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.tagColor, range: range)
            attributedString.addAttribute(NSAttributedString.Key.font, value: font!, range: range)
        }
        return attributedString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

