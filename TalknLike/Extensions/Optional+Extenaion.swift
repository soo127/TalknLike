//
//  Optional+Extenaion.swift
//  TalknLike
//
//  Created by 이상수 on 7/31/25.
//

import Foundation

extension Optional {

    @discardableResult
    func handleSome(_ handler: (Wrapped) -> Void) -> Self {
        if let value = self {
            handler(value)
        }
        return self
    }
    
    @discardableResult
    func handleSome(_ handler: (Wrapped) throws -> Void) rethrows -> Self {
        if let value = self {
            try handler(value)
        }
        return self
    }
    
    @discardableResult
    func handleSome(_ handler: (Wrapped) async throws -> Void) async rethrows -> Self {
        if let value = self {
            try await handler(value)
        }
        return self
    }
    
    @discardableResult
    func handleNone(_ handler: () -> Void) -> Self {
        if self == nil {
            handler()
        }
        return self
    }
    
    @discardableResult
    func handleNone(_ handler: () throws -> Void) rethrows -> Self {
        if self == nil {
            try handler()
        }
        return self
    }
    
    @discardableResult
    func handleNone(_ handler: () async throws -> Void) async rethrows -> Self {
        if self == nil {
            try await handler()
        }
        return self
    }
    
}
