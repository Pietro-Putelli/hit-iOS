//
//  _Image.swift
//  Hit
//
//  Created by Pietro Putelli on 03/09/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

extension Database.Image {
    
    class func download(withURL url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, responseURL, error) in
            var downloadedImage: UIImage?
            
            if let data = data  {
                downloadedImage = UIImage(data: data)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        dataTask.resume()
    }
    
    static let cache = NSCache<NSString, UIImage>()
    
    class func get(withURL url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
                completion(image)
            }
        } else {
            download(withURL: url, completion: completion)
        }
    }
    
    class func upload(image: UIImage?, parameters: [String:String]?, completion: @escaping (Bool) -> ()) {
        guard let image = image else { return }

        let boundary = ImageBoundary.generate()
        let url = URL(string: Php.User.UploadImage)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpBody = ImageBoundary.createBody(parameters: parameters, image: image, boundary: boundary)

        URLSession.shared.dataTask(with: request as URLRequest) {
            (data,_,error) in

            guard let data = data else { return }

            do {
                guard let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Bool] else {
                    return
                }
                DispatchQueue.main.async {
                    completion(response["response"]!)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

class ImageBoundary {
    
    class func createBody(parameters: [String: String]?, image: UIImage, boundary: String) -> Data {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "profile.png"
        let mimetype = "image/png"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=file; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(image.toData!)
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body as Data
    }
    
    class func generate() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
