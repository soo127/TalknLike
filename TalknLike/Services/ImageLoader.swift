//
//  ImageLoader.swift
//  TalknLike
//
//  Created by 이상수 on 7/29/25.
//

import UIKit

enum ImageLoader {

    private static var cache = NSCache<NSString, UIImage>()
    
    static func cachedMyProfileImage(from urlString: String?) -> UIImage? {
        guard let urlString else {
            return nil
        }
        return cache.object(forKey: urlString as NSString)
    }
    
    static func updateMyProfileImageCache(from urlString: String?) async {
        do {
            guard let urlString, let url = URL(string: urlString) else {
                throw LoadError.invalidURL
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw LoadError.invalidData
            }
            cache.setObject(image, forKey: urlString as NSString)
        } catch {
            print("ImageLoader error: \(error)")
        }
    }
    
    static func loadImage(from urlString: String?) async -> UIImage? {
        do {
            guard let urlString, let url = URL(string: urlString) else {
                throw LoadError.invalidURL
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw LoadError.invalidData
            }
            return image
        } catch {
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
