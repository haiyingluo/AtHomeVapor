//
//  UserController.swift
//  AtHomeVapor
//
//  Created by Apprenant 166 on 18/10/2024.
//

import Vapor
import FluentSQL

struct UserController: RouteCollection {
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: index)
        users.post(use: create)
        //http://127.0.0.1:8081/users/byemail/?email=pierre@gmail.com
        //users.get("byemail", use: self.getUserByEmail)
        //http://127.0.0.1:8081/users/byemail/pierre@gmail.com
        users.group("byemail") { user in
            user.get(":email", use: getUserByEmail)
        }
        users.group(":userID") { user in
            user.get(use: getUserById)
            user.delete(use: delete)
            user.put(use: update)
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [UserDTO] {
        let users = try await User.query(on: req.db).all()
        return users.map { $0.toDTO() }
    }
    
    @Sendable
    func create(req: Request) async throws -> UserDTO {
        let user = try req.content.decode(User.self)
        try await user.save(on: req.db)
        return user.toDTO()
    }
    
    @Sendable
    func getUserById(req: Request) async throws -> UserDTO {
        guard let user = try await
            User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user.toDTO()
    }
    
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus{
        guard let user = try await
            User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await user.delete(on: req.db)
        return .noContent
    }
    
    @Sendable
    func update(req: Request) async throws -> UserDTO {
       guard let userIDString = req.parameters.get("userID"),
              let userID = UUID(uuidString: userIDString) else {
           throw Abort(.badRequest, reason: "userID is not valid")
        }
        
        let updatedUser = try req.content.decode(User.self)
        
        guard let user = try await User.find(userID, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        
        user.name = updatedUser.name
        user.email = updatedUser.email
        user.password = updatedUser.password
        user.bestStreak = updatedUser.bestStreak
        user.actualStreak = updatedUser.actualStreak
        
        try await user.save(on: req.db)
        return user.toDTO()
    }
    
    @Sendable
    func getUserByEmail(req: Request) async throws -> UserDTO {
        //http://127.0.0.1:8081/users/byemail/?email=pierre@gmail.com
        //guard let email = req.query["email"] as String? else {
        //http://127.0.0.1:8081/users/byemail/pierre@gmail.com
        guard let email = req.parameters.get("email") as String? else {
            throw Abort(.badRequest, reason: "email is not valid")
        }
        
        if let sql = req.db as? SQLDatabase {
            let users = try await sql.raw("SELECT * FROM user WHERE email_user = \(bind: email)").all (decodingFluent: User.self)
            
            guard let user = users.first else {
                throw Abort(.notFound, reason: "User not found")
            }
            return user.toDTO()
        }
        throw Abort(.internalServerError, reason: "Database is not SQL")
    }
}
