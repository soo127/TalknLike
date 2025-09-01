//
//  AuthError.swift
//  TalknLike
//
//  Created by 이상수 on 9/1/25.
//

enum AuthError: Error {
    case userNotFound
    case invalidCredentials
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "사용자를 찾을 수 없습니다"
        case .invalidCredentials:
            return "잘못된 인증 정보입니다"
        case .networkError:
            return "네트워크 오류가 발생했습니다"
        }
    }
}
