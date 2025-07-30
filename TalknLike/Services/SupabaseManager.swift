//
//  SupabaseManager.swift
//  TalknLike
//
//  Created by 이상수 on 7/28/25.
//

import UIKit
import Supabase

enum SupabaseManager {
    
    static let client = SupabaseClient(
        supabaseURL: URL(string: Constants.supabaseURL)!,
        supabaseKey: Constants.supabaseKey
    )
    
    static func uploadImage(_ image: UIImage,
                            fileName: String,
                            bucket: Bucket) async throws {
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            throw UploadError.invalidData
        }
        
        try await client.storage.from(bucket.rawValue)
            .upload(fileName, data: data, options: FileOptions(contentType: "image/jpeg", upsert: true))
    }
    
    static func publicImageURL(fileName: String, bucket: Bucket) -> String {
        return "\(Constants.supabaseURL)/storage/v1/object/public/\(bucket.rawValue)/\(fileName)"
    }

}

extension SupabaseManager {
    
    enum Bucket: String {
        case profileImages = "profile-images"
        case postImages = "post-images"
    }
    
    fileprivate enum Constants {
        static let supabaseURL = "https://vfdvogjunotsjxblvbpm.supabase.co"
        static let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZmZHZvZ2p1bm90c2p4Ymx2YnBtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM2ODkwNjksImV4cCI6MjA2OTI2NTA2OX0.RzztOarfN9B-JDKnyEHwQbRSq04EjEYOM3n1HPo6c94"
    }
    
    fileprivate enum UploadError: Error {
        case invalidData
    }
    
}
