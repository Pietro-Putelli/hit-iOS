//
//  CreateCommentViewController.swift
//  Hit
//
//  Created by Pietro Putelli on 29/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class CreateCommentViewController: UIViewController {
    
    // MARK: - Models
    
    lazy var dismissButton: BounceView = {
        let button = BounceView(image: Images.SystemIcon.XMark, padding: 8)
        button.delegate = self
        button.tintColor = .white(alpha: 0.8)
        return button
    }()
    
    lazy var postButton: PostButton = {
        let button = PostButton()
        button.addTarget(self, action: #selector(post(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var textView: CommentTextView = {
        let textView = CommentTextView(isEditable: true)
        textView.delegate(self)
        textView.backgroundColor = .mardiGras
        return textView
    }()
    
    lazy var anonymousButton: AnonymousButton = {
        let button = AnonymousButton()
        button.addTarget(self, action: #selector(anonymous(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var tagView: TagView = {
        let view = TagView(frame: tagViewFrame)
        view.delegate = self
        return view
    }()
    
    lazy var profileImageView: ProfileImageView = {
       let imageView = ProfileImageView()
        imageView.isOnlineHidden = true
        imageView.isBouncingEnalble = true
        imageView.setupBorder(side: self.profileImageViewSize.width)
        imageView.image = User.shared.imageData?.toImage
        imageView.pulseTap.addTarget(self, action: #selector(switchAnonymous(_:)))
        return imageView
    }()
    
    // MARK: - Proprieties
    
    var textViewHeight: CGFloat {
        return UIScreen.main.bounds.height * 0.4
    }
    
    var tagViewFrame: CGRect {
        return .init(origin: .init(x: 0, y: view.frame.height), size: .init(width: view.frame.width, height: view.frame.height - keyboardHeight))
    }
    
    var isAnonymous: Bool = false {
        didSet {
            let image = isAnonymous ? nil : User.shared.imageData?.toImage
            profileImageView.image = image
        }
    }
    
    var isSnailEnable: Bool = true
    var maxCharacters: Int = 300
    
    var keyboardHeight: CGFloat = 0
    
    private let dismissButtonSize: CGSize = .init(side: 40)
    private let postButtonSize: CGSize = .init(width: 72, height: 36)
    private let anonymousButtonSize: CGSize = .init(side: 40)
    private let profileImageViewSize: CGSize = .init(side: 50)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        addConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textView.becomeFirstResponder()
    }
    
    private func setupSubviews() {
        view.addSubviews(dismissButton, textView, postButton, profileImageView)
        
        view.backgroundColor = .maire
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func addConstraints() {
        dismissButton.anchorWidthHeight(size: dismissButtonSize)
        postButton.anchorWidthHeight(size: postButtonSize)
        profileImageView.anchorWidthHeight(size: profileImageViewSize)
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            postButton.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
            postButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            textView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 12),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            textView.heightAnchor.constraint(equalToConstant: textViewHeight),
            
            profileImageView.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: -12),
            profileImageView.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -12)
        ])
    }
    
    @objc private func switchAnonymous(_ tap: UITapGestureRecognizer) {
        isAnonymous = !isAnonymous
    }
    
    private func showTagView(_ show: Bool) {
        let yOrigin = show ? windowSafeAreaInsets.top + 8 : view.frame.height
        
        textView.autocorrectionType = .no
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.tagView.frame.origin.y = yOrigin
        }, completion: nil)
    }
}

// MARK: - Objective C functions

extension CreateCommentViewController {
    @objc private func post(_ button: UIButton) {
        button.pulse(hapticFeedback: true, scaleBy: 0.95)
        
        let comment = CreateComment(authorId: User.shared.id, content: textView.text.removeAllExtraNewLines, taggedUsers: textView.getTaggedUsers() ?? [], anonymous: true, date: .hours24Current)
        
        Database.CommentDb.createComment(comment: comment) { [weak self] (successfull) in
            if successfull {
                NotificationCenter.default.post(name: .refreshHome, object: nil, userInfo: nil)
                self?.view.endEditing(true)
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc private func anonymous(_ button: AnonymousButton) {
        button.isShown = !button.isShown
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        keyboardHeight = keyboardFrame.height + windowSafeAreaInsets.bottom - 24
        view.addIfNotAlreadyIt(tagView)
    }
}

extension CreateCommentViewController: BounceViewDelegate {
    func touchesEnded(_ bounceView: BounceView) {
        UIView.animate(withDuration: 0.2) {
            self.dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.view.endEditing(true)
            }
        }
    }
}

// MARK: - TextView Delegates

extension CreateCommentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let commentTextView = textView as! CommentTextView
        
        commentTextView.highlightsTags()
        showTagView(commentTextView.isInTagRange)
        
        if commentTextView.isInTagRange {
            tagView.inputText = commentTextView.lastWord
        }
        
        commentTextView.placeholderLabel.hide(!textView.text.isEmpty)
        postButton.isEnabled = !textView.text.emptyIfNil.containsOnlyWhiteSpacesOrNewLines
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < maxCharacters
    }
}

// MARK: - CommentTextView Delegate

extension CreateCommentViewController: CommentTextViewDelegate {
    func commentTextViewDidChange(_ textView: CommentTextView) {
        textViewDidChange(textView)
    }
}

// MARK: - TagView Delegate

extension CreateCommentViewController: TagViewDelegate {
    func didSelect(_ user: UserDB) {
        showTagView(false)
        textView.replaceTextAfterSnail(with: "\(user.username) ")
    }
}
