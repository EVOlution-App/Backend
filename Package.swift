import PackageDescription

let package = Package(
    name: "SwiftEvolutionBackend",
    targets: [
      Target(name: "Server", dependencies: [.Target(name: "SwiftEvolutionBackend")])
    ],
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1),
        .Package(url: "https://github.com/RuntimeTools/SwiftMetrics.git", majorVersion: 1),
        .Package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", majorVersion: 1)
    ]
)
