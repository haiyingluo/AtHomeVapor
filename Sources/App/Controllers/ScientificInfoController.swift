//
//  ScientificInfoController.swift
//  atHomeVapor
//
//  Created by Apprenant 171 on 18/10/2024.
//

import Vapor
import Fluent
import FluentSQL

struct ScientificInfoController: RouteCollection {
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let scientificInfoRoutes = routes.grouped("scientificInfos")
        scientificInfoRoutes.get(use: indexScientificInfo)
        scientificInfoRoutes.post(use: createScientificInfo)
        scientificInfoRoutes.group("object") { scientificInfoRoute in
            scientificInfoRoute.get(":ByObjectID", use: getScientificInfoByID)
        }
        scientificInfoRoutes.group(":ScientificInfoID") { scientificInfoRoute in
            scientificInfoRoute.get(use: getScientificInfoByID)
            scientificInfoRoute.delete(use: deleteScientificInfo)
            scientificInfoRoute.put(use: updateScientificInfo)
        }
    }

    // Récupérer tous les ScientificInfo de la database
    @Sendable
    func indexScientificInfo(req: Request) async throws -> [ScientificInfo] {
        return try await ScientificInfo.query(on: req.db).all()
    }

    // Récupérer un ScientificInfo par son ID
    @Sendable
    func getScientificInfoByID(req: Request) async throws -> ScientificInfo {
        guard let scientificInfo = try await
                ScientificInfo.find(req.parameters.get("ScientificInfoID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return scientificInfo
    }
    
    // Créer un objet ScientificInfo
    @Sendable
       func createScientificInfo(req: Request) async throws -> ScientificInfo {
           let scientificInfo = try req.content.decode(ScientificInfo.self)
           try await scientificInfo.save(on: req.db)
           return scientificInfo
       }

       // Modifier un objet ScientificInfo
       @Sendable
       func updateScientificInfo(req: Request) async throws -> ScientificInfo {
           guard let scientificInfoIDString = req.parameters.get("ScientificInfoID"),
                 let scientificInfoID = UUID(scientificInfoIDString) else {
               throw Abort(.badRequest, reason: "ID d'utilisateur invalide")
           }
           let updatedScientificInfo = try req.content.decode(ScientificInfo.self)

           guard let scientificInfo = try await ScientificInfo.find(scientificInfoID, on: req.db) else {
               throw Abort(.notFound, reason: "ScientificInfo non trouvé")
           }

           scientificInfo.title_scientific_info = updatedScientificInfo.title_scientific_info
           scientificInfo.text_scientific_info = updatedScientificInfo.text_scientific_info

           try await scientificInfo.save(on: req.db)
           return scientificInfo
       }

       // Supprimer un objet ScientificInfo
       @Sendable
       func deleteScientificInfo(req: Request) async throws -> HTTPStatus {
           guard let scientificInfo = try await
                   ScientificInfo.find(req.parameters.get("ScientificInfoID"), on: req.db) else {
               throw Abort(.notFound)
           }
           try await scientificInfo.delete(on: req.db)
           return .noContent
       }
    
    // Récupérer le titre et le texte de toutes les infos scientifiques en fonction de l'id d'un objet
    @Sendable
    func getScientificInfoByObjectID(req: Request) async throws -> [ScientificInfo] {
        guard let object = req.query["object"] as String? else {
            throw Abort(.badRequest, reason: "Missing object ID")
        }
        if let sql = req.db as? SQLDatabase {
            let objects = try await sql.raw("SELECT title_scientific_info, text_scientific_info FROM scientific_info WHERE id_scientific_info IN(id_object FROM object  WHERE id_object = \(bind: object))")
                .all(decodingFluent: ScientificInfo.self)
            
                    return objects
        }
        throw Abort(.internalServerError, reason: "Database connection failed")
    }

   }
