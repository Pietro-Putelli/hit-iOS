//
//  ImageManager.swift
//  chat
//
//  Created by Pietro Putelli on 17/06/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class ImageManager {
    
    enum ImageType: String {
        case chat = "C"
        case profile = "P"
    }
    
    static var cache = NSCache<NSString,UIImage>()
    
    func filePath(forKey key: Int?, imageType: ImageType) -> URL? {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
                let key = key else { return nil }
        return documentUrl.appendingPathComponent("\(imageType.rawValue)-\(key)" + ".png")
    }
    
    func save(image: UIImage?, forKey key: Int?, imageType: ImageType) {
        guard let key = key, let image = image else { return }
        if let pngRepresentation = image.pngData() {
            if let filePath = filePath(forKey: key, imageType: imageType) {
                ImageManager.cache.setObject(image, forKey: filePath.path as NSString)
                do {
                    try pngRepresentation.write(to: filePath, options: .atomic)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func retrive(forKey key: Int?, imageType: ImageType) -> UIImage? {
        guard let key = key else { return nil }
        if let filePath = filePath(forKey: key, imageType: imageType) {
            guard let image = ImageManager.cache.object(forKey: filePath.path as NSString) else {
                if let fileData = FileManager.default.contents(atPath: filePath.path),
                    let image = UIImage(data: fileData) {
                    ImageManager.cache.setObject(image, forKey: filePath.path as NSString)
                    return image
                }
                return nil
            }
            return image
        }
        return nil
    }
    
    func delete(forKey key: Int?, imageType: ImageType) {
        guard let key = key else { return }
        if let filePath = filePath(forKey: key, imageType: imageType) {
            if let _ = ImageManager.cache.object(forKey: filePath.path as NSString) {
                ImageManager.cache.removeObject(forKey: filePath.path as NSString)
            }
            do {
                try FileManager.default.removeItem(at: filePath)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
