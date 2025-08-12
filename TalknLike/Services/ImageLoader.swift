//
//  ImageLoader.swift
//  TalknLike
//
//  Created by 이상수 on 7/29/25.
//

import UIKit

enum ImageLoader {

    private static var cache = NSCache<NSString, UIImage>()

    static func loadImage(from urlString: String?) async -> UIImage? {
        guard let urlString, let url = URL(string: urlString) else {
            return nil
        }
        if let cached = cache.object(forKey: urlString as NSString) {
            return cached
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw LoadError.invalidData
            }
            cache.setObject(image, forKey: urlString as NSString)
            return image
        } catch {
            print("ImageLoader error: \(error)")
            return nil
        }
    }

}

extension ImageLoader {
    
    enum LoadError: Error {
        case invalidURL
        case invalidData
    }
    
}
