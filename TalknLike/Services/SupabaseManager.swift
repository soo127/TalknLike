//
//  SupabaseManager.swift
//  TalknLike
//
//  Created by 이상수 on 7/28/25.
//

import Foundation
import Supabase

enum SupabaseManager {

    static let client = SupabaseClient(
        supabaseURL: URL(string: Constants.supabaseURL)!,
        supabaseKey: Constants.supabaseKey
    )
    
    static func imageBucket() -> StorageFileApi {
        return client.storage.from(Constants.imageBucketName)
    }
    
    static func publicImageURL(for fileName: String) -> String {
        return Constants.imageURL + fileName
    }
    
}

extension SupabaseManager {
    
    fileprivate enum Constants {
        static let supabaseURL = "https://vfdvogjunotsjxblvbpm.supabase.co"
        static let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZmZHZvZ2p1bm90c2p4Ymx2YnBtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM2ODkwNjksImV4cCI6MjA2OTI2NTA2OX0.RzztOarfN9B-JDKnyEHwQbRSq04EjEYOM3n1HPo6c94"
        static let imageBucketName = "profile-images"
        static let imageURL = "\(supabaseURL)/storage/v1/object/public/profile-images/"
    }
    
}
