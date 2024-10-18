//
//  ObjectController.swift
//  AtHomeVapor
//
//  Created by Apprenant 162 on 18/10/2024.
//
import Vapor
import Fluent
import FluentSQL


struct ObjectController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let objects = routes.grouped("objects")
       
        objects.get(use: self.index)
        objects.post(use: self.create)
        objects.group(":objectID") { object in
            object.delete(use: self.delete)
        }
    }
    
    @Sendable
    
    func index(req: Request) async throws -> [ObjectModel] {
        return try await ObjectModel.query(on: req.db).all()
        
    }
    
    @Sendable
    func create(req: Request) async throws -> ObjectModel {
        let object = try req.content.decode(ObjectModel.self)
        try await object.save(on: req.db)
        return object
    }
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let object = try await
                ObjectModel.find(req.parameters.get("objectID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await object.delete(on: req.db)
        return .noContent
    }
}
