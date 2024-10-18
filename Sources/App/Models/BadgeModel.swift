//
//  BadgeModel.swift
//  AtHomeVapor
//
//  Created by Apprenant 141 on 18/10/2024.
//

import Fluent
import Vapor

final class Badge : Model, Content, @unchecked Sendable {
    static let schema = "badge"
    
    @ID(custom: "id_badge")
    var id: UUID?
    
    @Field(key: "name_badge")
    var name: String
    
    @Field(key: "progression_badge")
    var progression: Double
    
    @Field(key: "objective_badge")
    var objective: Double
    
    init() {}
}
