//
// UserDTO.swift
//  AtHomeVapor
//
//  Created by Apprenant 166 on 18/10/2024.
//

import Vapor

struct UserDTO: Content {
    let id: UUID?
    let name: String
    let email: String
    let bestStreak: Int
    let actualStreak: Int
    
    func toModel() -> User {
        return User(id: id, name: name, email: email, password: "default", bestStreak: bestStreak, actualStreak: actualStreak)
    }
}
