//
//  ObjectModel.swift
//  AtHomeVapor
//
//  Created by Apprenant 162 on 18/10/2024.
//
import Vapor
import Fluent

final class ObjectModel: Model, Content, @unchecked Sendable {
    
    static let schema = "object"
    
    @ID(custom: "id_object")
    var id: UUID?
    
    @Field(key: "name_object")
    var name: String
    
    @Field(key: "image_object")
    var image: String
    
    @Field(key: "description_object")
    var description: String
    
    @Field(key: "creation_date_object")
    var creationDate: Date
    
    init() {}
    
    init(id: UUID?, name: String, image: String, description: String, creationDate: Date) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
        self.creationDate = creationDate
    }
    
}
