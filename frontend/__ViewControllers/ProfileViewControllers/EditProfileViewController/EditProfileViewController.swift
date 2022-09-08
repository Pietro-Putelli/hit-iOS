//
//  EditProfileViewController.swift
//  searchBar
//
//  Created by Pietro Putelli on 05/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit
import RSKImageCropper

@objc protocol EditProfileViewControllerDelegate: class {
    func presentImagePicker()
    @objc optional func enableDoneButton(_ enabled: Bool)
}

class EditProfileViewController: NavigationBarViewController {
    
    // MARK: - Models
    
    struct CellIdentifiers {
        static let profileImageCell = "profileImageCell"
        static let usernameCell = "usernameCell"
        static let nameCell = "nameCell"
        static let bioCell = "bioCell"
        static let iconMainCell = "iconMainCell"
    }
    
    lazy var collectionView: SettingsCollectionView = {
        let cv = SettingsCollectionView()
        cv.register(ProfileImageViewCell.self, forCellWithReuseIdentifier: CellIdentifiers.profileImageCell)
        cv.register(UsernameEditCell.self, forCellWithReuseIdentifier: CellIdentifiers.usernameCell)
        cv.register(NameEditCell.self, forCellWithReuseIdentifier: CellIdentifiers.nameCell)
        cv.register(BioEditCell.self, forCellWithReuseIdentifier: CellIdentifiers.bioCell)
        cv.register(IconMainEditCell.self, forCellWithReuseIdentifier: CellIdentifiers.iconMainCell)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    lazy var photoLibraryView: RubberCollectionView = {
        let rubberView = RubberCollectionView(frame: .init(origin: .init(x: 0, y: view.frame.height), size: view.frame.size), yLimit: 0.9, multipleSelection: false)
        rubberView.delegate = self
        rubberView.collectionViewDelegate = self
        return rubberView
    }()
    
    // MARK: - Proprieties
    
    var bioTextViewWidth: CGFloat {
        return view.frame.width - 40
    }
    
    var finalY: CGFloat {
        return 0.1 * view.frame.height
    }
    
    private let topButtonSize: CGSize = .init(width: 40, height: 40)
    private let topButtonPadding: CGFloat = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        addConstraints()
        addScreenEdgeDismissingGesture()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    
    private func setupSubviews() {
        view.addSubviews(collectionView, photoLibraryView)
        view.backgroundColor = .mardiGras
        
        navigationBar.setup(.settings, chevron: .down)
        navigationBar.title = "profile".uppercased()
        navigationBar.delegate = self
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func uploadUserData() {
        if let username = TemporaryUserSettings.username {
            User.shared.set(username, type: .username)
        }
        if let name = TemporaryUserSettings.name {
            User.shared.set(name, type: .name)
        }
        if let bio = TemporaryUserSettings.bio {
            User.shared.set(bio, type: .bio)
        }
        if let instagram = TemporaryUserSettings.instagram {
            User.shared.set(instagram, type: .instagram)
        }
        if let link = TemporaryUserSettings.link {
            User.shared.set(link, type: .link)
        }
        
        navigationBar.rightButton.startLoading()
        Database.User.editUserData { [weak self] (ended) in
            if ended {
                self?.navigationBar.rightButton.stopLoading()
                self?.motionDismissViewController()
            }
        }
    }
}

// MARK: - UICollectionView Delegate

extension EditProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.profileImageCell, for: indexPath) as! ProfileImageViewCell
            cell.delegate = self
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.usernameCell, for: indexPath) as! UsernameEditCell
            cell.setup(titleText: "Username", textFieldText: User.shared.username)
            cell.delegate = self
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.nameCell, for: indexPath) as! NameEditCell
            cell.setup(titleText: "Name", textFieldText: User.shared.name)
            cell.delegate = self
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.bioCell, for: indexPath) as! BioEditCell
            cell.setup(textViewText: User.shared.bio)
            if User.shared.bio != TemporaryUserSettings.bio && TemporaryUserSettings.bio != nil {
                cell.setup(textViewText: TemporaryUserSettings.bio)
            }
            return cell
        case 4,5,6:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.iconMainCell, for: indexPath) as! IconMainEditCell
            guard indexPath.item == 4 else {
                guard indexPath.item == 5 else {
                    cell.setup(type: .password, textFieldText: "Change Password")
                    return cell
                }
                cell.setup(type: .link, textFieldText: User.shared.link)
                return cell
            }
            cell.setup(type: .instagram, textFieldText: User.shared.instagram)
            return cell
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 3 || indexPath.item == 6 {
            let viewController = (indexPath.item == 3) ? BioEditViewController() : PasswordEditViewController()
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        if indexPath.item == 0 {
            view.endEditing(true)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 0
        switch indexPath.item {
        case 0: height = 120
        case 1,2,4,5,6: height = 80
        case 3:
            var text: String = User.shared.bio
            if User.shared.bio != TemporaryUserSettings.bio && TemporaryUserSettings.bio != nil {
                text = TemporaryUserSettings.bio!
            }
            height = UITextView().getTextViewHeight(width: bioTextViewWidth, text: text, font: Fonts.Main.withSize(14)) + 36
            default: break
        }
        return .init(width: view.frame.width, height: height)
    }
}

// MARK: - BounceView Delegate

extension EditProfileViewController: BounceViewDelegate {
    
    func touchesEnded(_ bounceView: BounceView) {
        view.endEditing(true)
        guard bounceView.tag == 0 else {
            motionDismissViewController()
            return
        }
        uploadUserData()
    }
}

// MARK: - Objective-C functions

extension EditProfileViewController {
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        collectionView.contentInset.bottom = keyboardFrame.height
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        collectionView.contentInset.bottom = 0
    }
}

// MARK: - EditProfileViewControllerDelegate

extension EditProfileViewController: EditProfileViewControllerDelegate {
    
    func presentImagePicker() {
        UIView.animate(withDuration: 0.4, animations: {
            self.photoLibraryView.originalFrame.origin = .init(x: 0, y: self.finalY)
        })
    }
    
    func enableDoneButton(_ enabled: Bool) {
        navigationBar.isDoneButtonEnabled = enabled
    }
}

// MARK: - RubberViewDelegate

extension EditProfileViewController: RubberViewDelegate, RubberCollectionViewDelegate {
    func didSelect(_ indexPath: IndexPath, image: UIImage?) {
        guard let image = image else { return }
        
        let imageCropViewController = RSKImageCropViewController(image: image, cropMode: .circle)
        imageCropViewController.delegate = self
        imageCropViewController.modalPresentationStyle = .fullScreen
        imageCropViewController.isMotionEnabled = true
        imageCropViewController.motionTransitionType = .autoReverse(presenting: .push(direction: .left))
        
        present(imageCropViewController, animated: true, completion: nil)
    }
    
    func viewDidDisappear() {
        becomeFirstResponder()
        photoLibraryView.prepareForReuse()
    }
    
    func didEndScrolling(_ panGesture: UIPanGestureRecognizer) {
        photoLibraryView.collectionView.isScrollEnabled = true
    }
}

// MARK: - RSKImageCropViewControllerDelegate

extension EditProfileViewController: RSKImageCropViewControllerDelegate {
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        photoLibraryView.dismiss()
        dismiss(animated: true, completion: nil)
        
        let image = croppedImage.resize(User.shared.profileImageSize)
        
        navigationBar.rightButton.isEnabled = false
        NotificationCenter.default.post(name: .profileImage, object: nil, userInfo: [Notification.Name.profileImage : image])
        navigationBar.rightButton.startLoading()
        
        ImageManager().save(image: image, forKey: User.shared.id, imageType: .profile)
        
        Database.Image.upload(image: image, parameters: ["userId":"\(User.shared.id)"]) { [weak self] (successfull) in
            if successfull {
                User.shared.imageData = image.pngData()
                self?.navigationBar.rightButton.isEnabled = true
                self?.navigationBar.rightButton.stopLoading()
            }
        }
    }
}
