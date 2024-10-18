//
//  SpaceModel.swift
//  AtHomeVapor
//
//  Created by Apprenant 176 on 18/10/2024.
//

import Vapor
import Fluent

final class Space: Model, Content, @unchecked Sendable {
    
    static let schema = "space"
    
    @ID(custom: "id_space")
    var id: UUID?
    
    @Field(key: "name_space")
    var name: String
    
    @Field(key: "image_space")
    var image: String
    
    init() {}
    
}
