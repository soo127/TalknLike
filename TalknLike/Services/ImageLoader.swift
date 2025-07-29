//
//  ImageLoader.swift
//  TalknLike
//
//  Created by 이상수 on 7/29/25.
//

import UIKit

//enum ImageLoader {
//    
//    static func loadImage(from urlString: String?, size: Int = 80) async throws -> UIImage? {
//        guard let urlString = urlString, let url = URL(string: urlString) else {
//            return nil
//        }
//        
//        let (data, _) = try await URLSession.shared.data(from: url)
//        return UIImage(data: data)
//    }
//    
//}

enum ImageLoader {

    private static var cache = NSCache<NSString, UIImage>()

    static func loadImage(from urlString: String?) async throws -> UIImage? {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return nil
        }
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            return cachedImage
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            return nil
        }
        cache.setObject(image, forKey: urlString as NSString)
        return image
    }
    
}
