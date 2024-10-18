//
//  SpaceController.swift
//  AtHomeVapor
//
//  Created by Apprenant 176 on 18/10/2024.
//

import Vapor
import Fluent

struct SpaceController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let spaces = routes.grouped("spaces")
        spaces.get(use: index)
        spaces.post(use: create)
        spaces.group(":spaceID") { space in
            space.get(use: getSpaceByID)
            space.delete(use: delete)
            space.put(use: update)
        }
    }
    
    @Sendable func index (req: Request) async throws -> [Space] {
        return try await Space.query(on: req.db).all()
    }
    
    @Sendable func create (req: Request) async throws -> Space {
        let space = try req.content.decode(Space.self)
        try await space.save(on: req.db)
        return space
    }
    
    @Sendable func getSpaceByID (req: Request) async throws -> Space {
        guard let space = try await Space.find(req.parameters.get("spaceID"), on: req.db) else {
            throw Abort(.notFound, reason: "Cette pièce n'existe pas")
        }
        return space
    }
    
    @Sendable func update (req: Request) async throws -> Space {
        let updatedSpace = try req.content.decode(Space.self)
        guard let spaceIDString = req.parameters.get("spaceID"), let spaceID = UUID(uuidString: spaceIDString) else {
            throw Abort(.badRequest, reason: "ID de la pièce invalide.")
        }
        
        guard let space = try await Space.find(spaceID, on: req.db) else {
            throw Abort(.notFound, reason: "Pièce non trouvée.")
        }
        
        space.name = updatedSpace.name
        space.image = updatedSpace.image
        
        try await space.save(on: req.db)
        return space
    }
    
    @Sendable func delete (req: Request) async throws -> HTTPStatus {
        guard let space = try await Space.find(req.parameters.get("spaceID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await space.delete(on: req.db)
        return .noContent
    }
}
