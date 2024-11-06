import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor
import JWT
import Gatekeeper

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.http.server.configuration.port = 8081
//    app.http.server.configuration.hostname = "0.0.0.0"
    
    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "root",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? "atHome_db"
    ), as: .mysql)
    
    guard let secret = Environment.get("SECRET_KEY") else {
        fatalError("No SECRET_KEY environment variable set")
    }
    
    let hmacKey = HMACKey(from: Data(secret.utf8))
    await app.jwt.keys.add(hmac: hmacKey, digestAlgorithm: .sha256)
    
    // codes pour trouver les chemins des sous dossiers de Public
    let fileMiddleware = FileMiddleware(publicDirectory: app.directory.publicDirectory)
    app.middleware.use(fileMiddleware)
    
    let corsConfiguration = CORSMiddleware.Configuration(
    allowedOrigin : .all,
    allowedMethods: [.GET, .POST, .PUT, .DELETE, .OPTIONS],
    allowedHeaders: [.accept, .authorization, .contentType, .origin],
    cacheExpiration: 800
    )
    
    let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
    // Ajout du middleware CORS à l'application
    app.middleware.use(corsMiddleware)
    
    app.caches.use(.memory)
    app.gatekeeper.config = .init(maxRequests: 5, per: .minute)
    app.middleware.use(GatekeeperMiddleware())
    
    app.middleware.use(JSONMiddleware())
    
    try routes(app)
}
