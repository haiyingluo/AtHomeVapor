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
        objects.get("spaces", ":spaceName", use: self.getObjectBySpace)
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
    
    @Sendable
    func getObjectBySpace(req: Request) async throws -> [ObjectModel] {
        guard let spaceName = req.parameters.get("spaceName") else {
            throw Abort(.badRequest, reason: "Nom de la pièce manquant")
        }
        if let sql = req.db as? SQLDatabase {
            let objects = try await sql.raw("SELECT obj.* FROM object obj JOIN space_own_object spa ON obj.id_object = spa.id_object JOIN space sp ON spa.id_space = sp.id_space WHERE sp.name_space = \(bind: spaceName)").all(decodingFluent: ObjectModel.self)
            return objects
        }
        throw Abort(.internalServerError, reason: "La base de données n'est pas SQL.")
    }
}
