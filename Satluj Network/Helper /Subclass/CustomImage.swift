//
//  CustomImage.swift
//  Chumsy
//
//  Created by eMobx Mac on 25/08/21.
//

import Foundation
import SDWebImage
import UIKit

enum ImageType {
    case medium
    case orignal
}


class CustomImage: UIImageView {
    
    var imgUrlString:String?
//    var imgkey:String?
    
    func loadImage(key: String, urlStr: URL,isProfile:Bool = false) {
        image = nil
        imgUrlString = key
        if let img = SDImageCache.shared.imageFromCache(forKey: key) {
            DispatchQueue.main.async { [weak self] in
                self?.image = img
            }
        }
        else {
            DispatchQueue.main.async { [weak self] in
                self?.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self?.sd_imageIndicator?.startAnimatingIndicator()
            }
            SDWebImageDownloader.shared.downloadImage(with: urlStr) { [weak self] image, data, error, isFinished in
                DispatchQueue.main.async { [weak self] in
                    self?.sd_imageIndicator?.stopAnimatingIndicator()
                    if isFinished, let img = image {
                        if self?.imgUrlString == key {
                            self?.image = img
                        }
                        SDImageCache.shared.store(img, forKey: key, completion: nil)
                    } else {
                        if isProfile{
                            self?.image = UIImage(named: "download")
                        }else{
                            self?.image = UIImage(named: "dummy")
                        }
                       
                        print("Unable to load: ", isFinished, "error: ", error?.localizedDescription ?? "Error")
                    }
                }
            }
        }
    }
}
