//
//  ScientificInfoModel.swift
//  atHomeVapor
//
//  Created by Apprenant 171 on 18/10/2024.
//

import Vapor
import Fluent

final class ScientificInfo: Model, Content,@unchecked Sendable {
    static let schema = "scientific_info"
    
    @ID(custom: "id_scientific_info")
    var id: UUID?
    
    @Field(key: "title_scientific_info")
    var title_scientific_info: String
    
    @Field(key: "text_scientific_info")
    var text_scientific_info: String
    
    @Field(key: "id_object")
    var id_object: UUID
    
    init() {}
}
