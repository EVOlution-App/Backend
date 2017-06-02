import CloudFoundryConfig
import Configuration

/**
 Constant settings to use throughout the application
 */
public struct Config {

    private let configuration: ConfigurationManager
    private let propertiesFile = "properties.json"

    static public let shared = Config()

    init() {
        configuration = ConfigurationManager()
            .load(file: "../../\(propertiesFile)")
            .load(file: propertiesFile, relativeFrom: .pwd)
            .load(.environmentVariables)
    }

    public var port: Int {
        return configuration.port
    }

    public var url: String {
        return configuration.url
    }
    
    // MARK: Templating Values
    
    var resourceTemplates: String {
        return configuration["serverResources:templates"] as? String ?? "./Resources/Templates/"
    }
    var staticResourceFiles: String {
        return configuration["serverResources:staticFiles"] as? String ?? "./Resources/public/"
    }
    var templateLanding: String {
        return configuration["templates:landing"] as? String ?? "index.stencil"
    }
    var templateShareProposal: String {
        return configuration["templates:shareProposal"] as? String ?? "share_index.stencil"
    }
    
    // MARK: URL and Link Reference Values
    
    var rawProposalsBaseURL: String {
        return configuration["common:urlBase:proposals"] as? String ?? "https://data.swift.org/swift-evolution/proposals"
    }
    func markdownBaseURL(_ link: String) -> String {
        let base = configuration["urlBase:markdown"] as? String ?? "https://raw.githubusercontent.com/apple/swift-evolution/master/proposals/"
        return base + link
    }
    func proposalBaseURL(_ link: String) -> String {
        let base = configuration["urlBase:proposal"] as? String ?? "https://github.com/apple/swift-evolution/blob/master/proposals/"
        return base + link
    }
    func proposalDeepLink(_ id: String) -> String {
        let base = configuration["deepLink:proposal"] as? String ?? "evo://proposal/"
        return base + id
    }
    func profileDeepLInk(_ username: String) -> String {
        let base = configuration["deepLink:profile"] as? String ?? "evo://username/"
        return base + username
    }
    
    // MARK: Common Utility Values
    
    var proposalRegex: String {
        return configuration["regex:proposalID"] as? String ?? "SE-([0-9]+)"
    }
    var bugRegex: String {
        return configuration["regex:bugID"] as? String ?? "SR-([0-9]+)"
    }
    
}
