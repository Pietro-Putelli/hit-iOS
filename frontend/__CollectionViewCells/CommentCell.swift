//
//  CommentCell.swift
//  
//
//  Created by Pietro Putelli on 22/07/2020.
//

import UIKit

protocol CommentCellDelegate: class {
    func pushLikedByViewController(commentId: Int)
    func presentShareView(commentId: Int)
    func pushProfileViewController(userId: Int)
}

class CommentCell: MainBaseCell {
    
    // MARK: - Models
    
    lazy var profileImageView: ProfileImageView = {
        let imgView = ProfileImageView()
        imgView.isOnlineHidden = true
        imgView.isBouncingEnalble = true
        imgView.pulseTap.addTarget(self, action: #selector(pushProfileViewController(_:)))
        imgView.setupBorder(side: profileImageViewSize.width)
        return imgView
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.Main.withSize(20)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.4)
        label.font = Fonts.Main.withSize(10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textView: CommentTextView = {
        let textView = CommentTextView(isEditable: false)
        textView.textContainerInset = .zero
        textView.font = Fonts.Main.withSize(16)
        textView.backgroundColor = .clear
        return textView
    }()
    
    lazy var likeButton = LikeButton()
    lazy var favouriteButton = FavouriteButton()
    
    lazy var shareButton: ShareButton = {
        let button = ShareButton()
        button.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var likedByLabel: FollowedByLabel = {
        let label = FollowedByLabel()
        label.textColor = .white
        label.font = Fonts.Main.withSize(11)
        return label
    }()
    
    lazy var doubleTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 2
        tap.delegate = self
        tap.addTarget(self, action: #selector(doubleTap(_:)))
        return tap
    }()
    
    lazy var likedByTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(likedBy(_:)))
        return tap
    }()
    
    // MARK: - Proprieties
    
    weak var delegate: CommentCellDelegate?
    
    var comment: Comment!
    
    static var shared = CommentCell()
    static let Height: CGFloat = 140
    
    lazy var lineWidth: CGFloat = 1.0
    
    private let slowValue: CGFloat = 1.6
    private var initialCenter: CGPoint!
    private var feedBackAlreadyGenerated: Bool = false
    
    private let likeButtonSize: CGSize = .init(width: 28, height: 26)
    private let profileImageViewSize: CGSize = .init(side: 50)
    private let rightButtonSize: CGSize = .init(side: 26)
    
    private var xLimit: CGFloat {
        return 0.35 * frame.width
    }
    
    private var textViewHeightConstraint: NSLayoutConstraint!
    
    private var textViewHeight: CGFloat {
        return ceil(textView.sizeThatFits(textView.frame.size).height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.imageView.image = nil
        likedByLabel.setText(nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        addConstraints()
    }
    
    private func setupSubviews() {
        addSubviews(profileImageView, usernameLabel, dateLabel, textView, likeButton, shareButton, favouriteButton, likedByLabel)
        addGestureRecognizer(doubleTap)
        likedByLabel.addGestureRecognizer(likedByTap)
        
        backgroundColor = .mardiGras
    }
    
    // MARK: - Setup Models functions
    
    private func setupTextViewHeight() {
        textViewHeightConstraint.isActive = false
        textViewHeightConstraint.constant = getTextViewHeight()
        textViewHeightConstraint.isActive = true
    }
    
    private func getTextViewHeight() -> CGFloat {
        let size = CGSize(width: frame.width - 36, height: .infinity)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: textView.text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: Fonts.Main.withSize(16)], context: nil)
        return estimatedFrame.height + 4
    }
    
    func setupCell(for comment: Comment) {
        self.comment = comment
        
        likeButton.commentId = comment.id
        favouriteButton.commentId = comment.id
        
        textView.text = comment.content
        
        setupTextViewHeight()
        
        usernameLabel.text = comment.username
        profileImageView.setupImage(userId: comment.userId)
        
        likeButton.isLiked = comment.liked
        favouriteButton.isFavourite = comment.favourited
        
        setupLikedByTitle(comment)
        
        guard let date = comment.date.toDate else { return }
        dateLabel.text = Date().days(sinceDate: date)
    }
    
    private func setupLikedByTitle(_ comment: Comment) {
        let usernames = comment.likedUsernames.commaSeparatedToStringArray
        guard usernames != [""] else {
            if comment.likedByCount > 0 {
                likedByLabel.text = "Liked by \(comment.likedByCount)"
            }
            return
        }
        var text = ""
        for username in usernames {
            text += "@\(username), "
        }
        text.removeLast(); text.removeLast()
        if comment.likedByCount - usernames.count > 0 {
            text += " and \(comment.likedByCount - usernames.count) others"
        }
        likedByLabel.setText(text)
    }
    
    // MARK: - Layout functions
    
    private func addConstraints() {
        profileImageView.anchorWidthHeight(size: profileImageViewSize)
        
        likeButton.anchorWidthHeight(size: likeButtonSize)
        
        favouriteButton.anchorWidthHeight(size: rightButtonSize)
        shareButton.anchorWidthHeight(size: rightButtonSize)
        
        textViewHeightConstraint = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        addConstraint(textViewHeightConstraint)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -16),
            
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            dateLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            textView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 4),
            textViewHeightConstraint,
            
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            likeButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 4),
            
            likedByLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 6),
            likedByLabel.leadingAnchor.constraint(equalTo: likeButton.leadingAnchor),
            
            favouriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            favouriteButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor, constant: 16),
            
            shareButton.centerYAnchor.constraint(equalTo: favouriteButton.centerYAnchor),
            shareButton.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor, constant: -12),
        ])
    }
    
    class func getCellHeight(comment: Comment, fontSize: CGFloat = 16) -> CGFloat {
        let size = CGSize(width: UIScreen.main.bounds.width - 56, height: .infinity)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: comment.content).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: Fonts.Main.withSize(fontSize)], context: nil)
        return estimatedFrame.height + 130
    }
    
    // MARK: - Objc functions
    
    @objc private func doubleTap(_ sender: UITapGestureRecognizer) {
        likeButton.buttonAction(likeButton)
    }
    
    @objc private func likedBy(_ gesture: UITapGestureRecognizer) {
        delegate?.pushLikedByViewController(commentId: comment.id)
    }
    
    @objc private func share(_ button: UIButton) {
        button.pulse()
        delegate?.presentShareView(commentId: comment.id)
    }
    
    @objc private func pushProfileViewController(_ gesture: UIGestureRecognizer) {
        delegate?.pushProfileViewController(userId: comment.userId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommentCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let rightButtonFrameSize = CGSize(width: 104, height: 68)
        let rightButtonFrame = CGRect(x: frame.width - rightButtonFrameSize.width, y: frame.height - rightButtonFrameSize.height,
                                      width: rightButtonFrameSize.width, height: rightButtonFrameSize.height)
        let location = touch.location(in: self)
        return !rightButtonFrame.contains(location)
    }
}
