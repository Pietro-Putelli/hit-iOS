//
//  RubberCollectionView.swift
//  RubberView
//
//  Created by Pietro Putelli on 10/06/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit
import Photos

protocol RubberCollectionViewDelegate: RubberViewDelegate {
    func didSelect(_ indexPath: IndexPath, image: UIImage?)
}

class RubberCollectionView: RubberView {

    // MARK: - Models
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect(origin: CGPoint(x: 0, y: 24 + titleLabel.frame.height), size: bounds.size), collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .clear
        cv.contentInset.bottom = cv.frame.height * (1 - yLimit) + cv.frame.origin.y
        cv.delegate = self
        cv.dataSource = self
        cv.register(PhotoCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Photo Album"
        label.sizeToFit()
        label.center = CGPoint(x: center.x, y: cursorView.center.y + label.frame.height)
        return label
    }()
    
    lazy var backgroundView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let viewEffect = UIVisualEffectView(effect: blur)
        viewEffect.frame = bounds
        viewEffect.layer.zPosition = -1
        return viewEffect
    }()
    
    let fetchOptions: PHFetchOptions = {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return options
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(frame: .init(origin: .zero, size: .init(width: frame.width - 32, height: 42)))
        button.center = .init(x: frame.width / 2, y: frame.height * yLimit + 200)
        button.setTitle("Send", for: .normal)
        button.layer.addGradient(colors: UIColor.purpleGradient)
        button.roundCorner()
        button.addTarget(self, action: #selector(sendButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }()
    
    let options: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        return options
    }()
    
    // MARK: - Proprieties
    
    weak var collectionViewDelegate: RubberCollectionViewDelegate?
    
    var isMultipleSelectionEnabled: Bool = true {
        didSet {
            maxPhotoSelected = isMultipleSelectionEnabled ? 8 : 1
        }
    }
    
    let sendButtonAnimationDuration: TimeInterval = 0.4
    var maxPhotoSelected: Int = 8
    
    var originalSendButtonYCenter: CGFloat = 0
    
    var selectedPhotoIndices = [Int]()
    var selectedPhotos = [UIImage?]()
    
    let dispatchGroup = DispatchGroup()
    
    var fetchResult: PHFetchResult<PHAsset>! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let imageManager = PHCachingImageManager()
    var thumbnailSize: CGSize = .init(width: 200, height: 200)
    
    init(frame: CGRect, yLimit: CGFloat, multipleSelection: Bool = true) {
        super.init(frame: frame, yLimit: yLimit)
        self.isMultipleSelectionEnabled = multipleSelection
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        
        addSubviews(backgroundView,titleLabel,collectionView,sendButton)
        
        originalSendButtonYCenter = sendButton.center.y
        
        panGesture.delegate = self
        
        verifyAuthentication()
    }
    
    @objc private func sendButton(_ sender: UIButton) {
        let indicies = selectedPhotoIndices
        
        dismiss()
        
        postImagesNotification(selectedPhotoIndicies: indicies)
    }
    
    private func postImagesNotification(selectedPhotoIndicies: [Int]) {
        var images = [UIImage?]()
        for selectedIndex in selectedPhotoIndicies {
            dispatchGroup.enter()
            let asset = fetchResult.object(at: selectedIndex)
            PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options, resultHandler: { image, _ in
                self.dispatchGroup.leave()
                images.append(image)
            })
        }
        dispatchGroup.notify(queue: .main) {
            NotificationCenter.default.post(name: .image, object: nil, userInfo: [Notification.Name.image : images])
        }
    }
    
    private func getImage(indexPath: IndexPath, completion: @escaping (UIImage?) -> ()) {
        let asset = fetchResult.object(at: indexPath.item)
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options, resultHandler: { image, _ in
            completion(image)
        })
    }
    
    func prepareForReuse() {
        selectedPhotoIndices = []
        selectedPhotos = []
        collectionView.reloadData()
        hideButton()
    }
    
    private func showButton() {
        guard sendButton.center.y == originalSendButtonYCenter else { return }
        UIView.animate(withDuration: sendButtonAnimationDuration, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.sendButton.center.y -= 250
        }, completion: nil)
    }
    
    private func hideButton() {
        UIView.animate(withDuration: sendButtonAnimationDuration, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.sendButton.center.y = self.originalSendButtonYCenter
        }, completion: nil)
    }
    
    private func verifyAuthentication() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.fetchResult = PHAsset.fetchAssets(with: .image, options: self.fetchOptions)
                }
            default:
                print("vaffanculo")
            }
        }
    }
}

extension RubberCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let fetchResult = fetchResult else { return 0 }
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = fetchResult.object(at: indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCell
        cell.isSelect = selectedPhotoIndices.contains(indexPath.item)
        
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.image = image
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell else { return }
        
        guard isMultipleSelectionEnabled else {
            getImage(indexPath: indexPath) { [weak self] (image) in
                self?.collectionViewDelegate?.didSelect(indexPath, image: image)
            }
            return
        }
        
        if !cell.isSelect && selectedPhotoIndices.count < maxPhotoSelected {
            cell.isSelect = !cell.isSelect
            if !selectedPhotoIndices.contains(indexPath.item) {
                selectedPhotoIndices.append(indexPath.item)
            }
        } else if cell.isSelect {
            cell.isSelect = !cell.isSelect
            if selectedPhotoIndices.contains(indexPath.item) {
                selectedPhotoIndices = selectedPhotoIndices.filter { $0 != indexPath.item }
            }
        }
        
        guard selectedPhotoIndices.count > 0 else {
            hideButton()
            return
        }
        showButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width / 3 - 1
        return .init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension RubberCollectionView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let panGesture = gestureRecognizer as! UIPanGestureRecognizer
        let direction = panGesture.velocity(in: self).y
        collectionView.isScrollEnabled = !(direction > 0 && collectionView.contentOffset.y == 0)
        return false
    }
}

