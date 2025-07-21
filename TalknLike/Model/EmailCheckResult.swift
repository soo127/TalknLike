//
//  EmailCheckResult.swift
//  TalknLike
//
//  Created by 이상수 on 7/21/25.
//

import UIKit

enum EmailCheckResult {
    case empty
    case available
    case duplicate
    case error
    
    var errorMessage: String {
        switch self {
        case .empty:
            return "이메일 필드를 필수로 채워주세요."
        case .available:
            return "사용 가능한 이메일입니다."
        case .duplicate:
            return "이미 존재하는 이메일입니다."
        default:
            return "오류가 발생했습니다."
        }
    }
    
    var isValid: Bool {
        switch self {
        case .available:
            return true
        default:
            return false
        }
    }
}
