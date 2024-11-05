//
//  JSONMiddleware.swift
//  AtHomeVapor
//
//  Created by Apprenant 141 on 04/11/2024.
//

import Vapor

struct JSONMiddleware : AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        
//        guard request.headers.contentType?.description == "application/json" else {
//            throw Abort(.unauthorized, reason: "Content-Type must be JSON")
//        }
        
        return try await next.respond(to: request)
    }
}
