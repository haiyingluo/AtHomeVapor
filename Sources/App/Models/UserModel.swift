//
//  UserModel.swift
//  AtHomeVapor
//
//  Created by Apprenant 166 on 18/10/2024.
//

import Vapor
import Fluent

final class User: Model, @unchecked Sendable {
    static let schema = "user"
    
    @ID(custom: "id_user")
    var id: UUID?
    
    @Field(key: "name_user")
    var name: String
    
    @Field(key: "email_user")
    var email: String
    
    @Field(key: "password_user")
    var password: String
    
    @Field(key: "best_streak_user")
    var bestStreak: Int
    
    @Field(key: "actual_streak_user")
    var actualStreak: Int
    
    init() {}
    
    init(id: UUID? = nil, name: String, email: String, password: String, bestStreak: Int, actualStreak: Int) {
        self.id = id ?? UUID()
        self.name = name
        self.email = email
        self.password = password
        self.bestStreak = bestStreak
        self.actualStreak = actualStreak
    }
    
    func toDTO() -> UserDTO {
        return UserDTO(id: self.id, name: self.name, email: self.email, bestStreak: self.bestStreak, actualStreak: self.actualStreak)
    }
}

extension User : ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
