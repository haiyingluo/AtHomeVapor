//
//  BadgeController.swift
//  AtHomeVapor
//
//  Created by Apprenant 141 on 18/10/2024.
//

import Fluent
import Vapor

struct BadgeController: RouteCollection {
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let badges = routes.grouped("badges")
        
        badges.get(use: index)
        badges.post(use: create)
        badges.group(":badgeID") { badge in
            badge.put(use: update)
            badge.delete(use: delete)
            badge.get(use: getByID)
        }
        
    }
    
    @Sendable func index(_ req: Request) async throws -> [Badge] {
        return try await Badge.query(on: req.db).all()
    }
    
    @Sendable func create(_ req: Request) async throws -> Badge {
        let badge = try req.content.decode(Badge.self)
        
        try await badge.save(on: req.db)
        
        return badge
    }
    
    @Sendable func getByID(_ req: Request) async throws -> Badge {
        guard let badge = try await Badge.find(req.parameters.get("badgeID"), on: req.db) else {
            throw Abort(.notFound, reason: "ID Not Found")
        }
        
        return badge
    }
    
    @Sendable func update(_ req: Request) async throws -> Badge {
        guard let badge = try await Badge.find(req.parameters.get("badgeID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedBadge = try req.content.decode(Badge.self)
        
        badge.name = updatedBadge.name
        badge.progression = updatedBadge.progression
        badge.objective = updatedBadge.objective
        try await badge.save(on: req.db)
        
        return badge
    }
    
    @Sendable func delete(_ req: Request) async throws -> HTTPStatus {
        guard let badge = try await Badge.find(req.parameters.get("badgeID"), on: req.db) else {
            throw Abort(.notFound, reason: "ID Not Found")
        }
        
        try await badge.delete(on: req.db)
        
        return .noContent
    }
}
