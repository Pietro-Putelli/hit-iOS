//
//  CommentTextView.swift
//  Hit
//
//  Created by Pietro Putelli on 03/09/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

@objc protocol CommentTextViewDelegate {
    @objc optional func commentTextViewDidChange(_ textView: CommentTextView)
    @objc optional func pushProfileViewController(username: String)
}

class CommentTextView: UITextView {
    
    // MARK: - Models
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white(alpha: 0.4)
        label.text = placeholderText
        label.font = self.font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(pushProfileViewController(_:)))

    // MARK: - Proprieties
    
    weak var commentDelegate: CommentTextViewDelegate?
    
    override var text: String! {
        didSet {
            invalidateIntrinsicContentSize()
            placeholderLabel.isHidden = !text.isEmpty
            highlightsTags()
        }
    }
    
    override var autocorrectionType: UITextAutocorrectionType {
        didSet {
            reloadInputViews()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if size.height == UIView.noIntrinsicMetric {
            layoutManager.glyphRange(for: textContainer)
            size.height = layoutManager.usedRect(for: textContainer).height + textContainerInset.top + textContainerInset.bottom
        }
        if maxHeight > 0.0 && size.height > maxHeight {
            size.height = maxHeight
            if !isScrollEnabled {
                isScrollEnabled = true
            }
        } else if isScrollEnabled {
            isScrollEnabled = false
        }
        return size
    }
    
    var fontSize: CGFloat = 20 {
        didSet {
            font = Fonts.Main.withSize(fontSize)
        }
    }
    
    var maxHeight: CGFloat {
        return UIScreen.main.bounds.height / 4
    }
    
    private let placeholderText = "Say something to the world..."
    private let placeholderLabelHeigt: CGFloat = 30
    private let maxCharactersCount = 300
    
    init(isEditable: Bool) {
        super.init(frame: .zero, textContainer: nil)
        
        font = Fonts.Main.withSize(fontSize)
        translatesAutoresizingMaskIntoConstraints = false
        isScrollEnabled = false
        isSelectable = false
        textColor = .white(alpha: 0.8)
        keyboardType = .twitter
        tintColor = .purple
        textContainerInset = .init(side: 16)
        self.isEditable = isEditable
        
        addSubview(placeholderLabel)
        addConstraints()
        
        if !isEditable {
            addGestureRecognizer(profileTapGesture)
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            placeholderLabel.heightAnchor.constraint(equalToConstant: placeholderLabelHeigt)
        ])
    }
    
    func delegate(_ delegate: CreateCommentViewController) {
        self.delegate = delegate
        self.commentDelegate = delegate
    }
    
    @objc private func pushProfileViewController(_ gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.location(in: self)
        
        guard let detectedWord = getWordAtPosition(point),
            let usernames = getTaggedUsers(),
            let index = usernames.firstIndex(of: detectedWord) else {
            return
        }
        commentDelegate?.pushProfileViewController!(username: usernames[index])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Text Handling

extension CommentTextView {
    
    func highlightsTags() {
        guard let regex = try? NSRegularExpression(pattern: "@([.\\w]+)", options: []),
                let text = text else { return }

        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
        let attString = NSMutableAttributedString(string: text)
        
        let range = NSMakeRange(0, text.count)
        
        attString.addAttribute(NSAttributedString.Key.font, value: font!, range: range)
        attString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.perla, range: range)
        
        for match in matches {
            let wordRange = match.range(at: 0)
            guard (text as NSString?)?.substring(with: wordRange) != nil else { return }
            
            let fullRange = NSRange(location: 0, length: text.count)
            attString.addAttribute(NSAttributedString.Key.font, value: font!, range: fullRange)
            attString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.tagColor, range: wordRange)
        }
        
        linkTextAttributes = [.underlineStyle: NSUnderlineStyle.single.rawValue]
        attributedText = attString
    }
    
    func replaceTextAfterSnail(with string: String) {
        if let selectedRange = selectedTextRange {
            let cursorOffset = offset(from: beginningOfDocument, to: selectedRange.start)
            if let text = text {
                let index = text.index(text.startIndex, offsetBy: cursorOffset)
                let substring = text[..<index]
                
                if let lastWord = substring.components(separatedBy: .whitespaces).last {
                    if lastWord.contains(.snail), let snailIndex = lastWord.firstIndex(of: .snail) {
                        var newText = text
                        let distance = lastWord.distance(from: text.startIndex, to: snailIndex)
                        let start = newText.index(text.startIndex, offsetBy: cursorOffset - lastWord.count + distance + 1)
                        let end = newText.index(text.startIndex, offsetBy: (cursorOffset - lastWord.count) + lastWord.count)
                        newText.replaceSubrange(start..<end, with: string)
                        self.text = newText
                        highlightsTags()
                    }
                }
            }
        }
    }
    
    var isInTagRange: Bool {
        if let selectedRange = selectedTextRange {
            let cursorOffset = offset(from: beginningOfDocument, to: selectedRange.start)
            if let text = text {
                let index = text.index(text.startIndex, offsetBy: cursorOffset)
                let substring = text[..<index]
                if let lastWord = substring.components(separatedBy: .whitespaces).last {
                    guard lastWord.contains(.snail) else {
                        autocorrectionType = .yes
                        return false
                    }
                    autocorrectionType = .no
                    return true
                }
            }
        }
        autocorrectionType = .yes
        return false
    }
    
    var lastWord: String {
        if let selectedRange = selectedTextRange {
            let cursorOffset = offset(from: beginningOfDocument, to: selectedRange.start)
            if let text = text {
                let index = text.index(text.startIndex, offsetBy: cursorOffset)
                let substring = text[..<index]
                var lastWord: String
                if let lastWordUnwrapped = substring.components(separatedBy: .whitespaces).last {
                    lastWord = lastWordUnwrapped
                    if lastWord.hasPrefix(.snail) {
                        return String(lastWord.dropFirst())
                    }
                }
            }
        }
        return ""
    }
    
    func getTaggedUsers() -> [String]? {
        guard let regex = try? NSRegularExpression(pattern: "@([.\\w]+)", options: []) else { return nil }
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))

        var usernames = [String]()
        
        for match in matches {
            let wordRange = match.range(at: 1)
            guard (text as NSString?)?.substring(with: wordRange) != nil else { return nil }
            let substring = text.stringFrom(wordRange: wordRange)
            usernames.append(substring)
        }
        return usernames
    }
    
    func getWordAtPosition(_ point: CGPoint) -> String? {
        if let textPosition = closestPosition(to: point) {
            if let range = tokenizer.rangeEnclosingPosition(textPosition, with: .word, inDirection: UITextDirection(rawValue: 1)) {
                return text(in: range)
            }
        }
        return nil
    }
}
