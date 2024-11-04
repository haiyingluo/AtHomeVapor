//
//  TokenSession.swift
//  AtHomeVapor
//
//  Created by Apprenant 141 on 04/11/2024.
//

import Vapor
import JWTKit

struct TokenSession: Content, Authenticatable, JWTPayload {
    var expirationTime: TimeInterval = 60 * 60 * 24 * 30
    
    // Token Data
    var expiration: ExpirationClaim
    var userId: UUID
    
    init(with user: User) throws {
        self.userId = try user.requireID()
        self.expiration = ExpirationClaim(value: Date().addingTimeInterval(expirationTime))
    }
    
    func verify(using algorithm: some JWTAlgorithm) throws {
        try expiration.verifyNotExpired()
    }
}
