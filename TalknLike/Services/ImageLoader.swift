//
//  ImageLoader.swift
//  TalknLike
//
//  Created by 이상수 on 7/29/25.
//

import UIKit

actor ImageLoader {
    static let shared = ImageLoader()
    private init() {}

    private var cache = NSCache<NSString, UIImage>()
    private var runningTasks: [String: Task<UIImage?, Error>] = [:]

    func loadImage(from urlString: String?) async -> UIImage? {
        guard let urlString, let url = URL(string: urlString) else {
            return nil
        }

        if let cached = cache.object(forKey: urlString as NSString) {
            return cached
        }

        if let existingTask = runningTasks[urlString] {
            return try? await existingTask.value
        }

        let task = Task {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        }

        runningTasks[urlString] = task

        let result = try? await task.value

        if let result {
            cache.setObject(result, forKey: urlString as NSString)
        }
        runningTasks.removeValue(forKey: urlString)

        return result
    }
}

extension ImageLoader {
    
    enum LoadError: Error {
        case invalidURL
        case invalidData
    }
    
}
