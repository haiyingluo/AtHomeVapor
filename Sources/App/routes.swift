import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    try app.register(collection: BadgeController())
    try app.register(collection: ObjectController())
    try app.register(collection: ScientificInfoController())
    try app.register(collection: SpaceController())
    try app.register(collection: UserController())
}
