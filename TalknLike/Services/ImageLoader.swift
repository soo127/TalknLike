//
//  ImageLoader.swift
//  TalknLike
//
//  Created by 이상수 on 7/29/25.
//

import UIKit

enum ImageLoader {

    private static var cache = NSCache<NSString, UIImage>()
    
    static func cachedImage(from urlString: String) -> UIImage? {
        return cache.object(forKey: urlString as NSString)
    }
    
    static func loadImage(from urlString: String) async throws -> UIImage {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            return cachedImage
        }
        guard let url = URL(string: urlString) else {
            throw ImageLoaderError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw ImageLoaderError.invalidData
        }
        cache.setObject(image, forKey: urlString as NSString)
        return image
    }

}
