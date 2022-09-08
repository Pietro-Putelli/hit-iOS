//
//  UITextViewExtension.swift
//  Hit
//
//  Created by Pietro Putelli on 03/02/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

extension UITextView {
    
    func getTextViewHeight(width: CGFloat, fontSize: CGFloat = 16) -> CGFloat {
        let size = CGSize(width: width - textContainerInset.left - textContainerInset.right, height: .infinity)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: font!.withSize(fontSize)], context: nil)
        return estimatedFrame.height + textContainerInset.top + textContainerInset.bottom
    }
    
    func getTextViewHeight(width: CGFloat, text: String, font: UIFont) -> CGFloat {
        let size = CGSize(width: width - textContainerInset.left - textContainerInset.right, height: .infinity)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: font], context: nil)
        return estimatedFrame.height + textContainerInset.top + textContainerInset.bottom
    }
}
