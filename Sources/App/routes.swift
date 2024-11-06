import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello ! C'est une requête GET"
    }
    
    app.post("hello") { req async -> String in
        "Hello ! C'est une requête POST"
    }
    
    app.put("hello") { req async -> String in
        "Hello ! C'est une requête PUT"
    }
    
    app.delete("hello") { req async -> String in
        "Hello ! C'est une requête DELETE"
    }
    
    try app.register(collection: BadgeController())
    try app.register(collection: ObjectController())
    try app.register(collection: ScientificInfoController())
    try app.register(collection: SpaceController())
    try app.register(collection: UserController())
}
