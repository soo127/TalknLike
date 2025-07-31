//
//  Result+Extension.swift
//  TalknLike
//
//  Created by 이상수 on 7/31/25.
//

import Foundation

extension Result {
    
    @discardableResult
    func onSuccess(_ handler: (Success) -> Void) -> Self {
        guard let value = try? self.get() else {
            return self
        }
        handler(value)
        return self
    }
    
    @discardableResult
    func onFailure(_ handler: (Failure) -> Void) -> Self {
        guard case let .failure(value) = self else {
            return self
        }
        handler(value)
        return self
    }
 
}
