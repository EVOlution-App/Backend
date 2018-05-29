import CloudFoundryConfig
import Configuration

/**
 Constant settings to use throughout the application
 */
public struct Config {

    /// Enum containing all json path keys for properties file
    private enum Keys: String {
        case resourceTemplates = "serverResources:templates"
        case staticResourceFiles = "serverResources:staticFiles"
        case templateLanding = "templates:landing"
        case templateShareProposal = "templates:shareProposal"
        case rawProposalsBaseURL = "common:urlBase:proposals"
        case markdownBaseURL = "urlBase:markdown"
        case proposalBaseURL = "urlBase:proposal"
        case proposalDeepLink = "deepLink:proposal"
        case profileDeepLink = "deepLink:profile"
        case proposalRegex = "regex:proposalID"
        case bugRegex = "regex:bugID"
    }

    private let configuration: ConfigurationManager
    private let propertiesFile = "properties.json"

    static public let shared = Config()

    init() {
        configuration = ConfigurationManager()
            .load(file: "../../\(propertiesFile)")
            .load(file: propertiesFile, relativeFrom: .pwd)
            .load(.environmentVariables)
    }

    public let cacheTimeout: Int = 900 // 15 minutes

    public var port: Int {
        let environment = ProcessInfo.processInfo.environment
        let port = Int(environment["PORT"]) ?? 8080

        return port
    }

    public var url: String {
        return configuration.url
    }

    // MARK: Templating Values

    var resourceTemplates: String {
        return configuration[Keys.resourceTemplates.rawValue] as? String ?? "./Resources/Templates/"
    }
    var staticResourceFiles: String {
        return configuration[Keys.staticResourceFiles.rawValue] as? String ?? "./Resources/public/"
    }
    var templateLanding: String {
        return configuration[Keys.templateLanding.rawValue] as? String ?? "index.stencil"
    }
    var templateShareProposal: String {
        return configuration[Keys.templateShareProposal.rawValue] as? String ?? "share_index.stencil"
    }

    // MARK: URL and Link Reference Values

    var rawProposalsBaseURL: String {
        return configuration[Keys.rawProposalsBaseURL.rawValue] as? String ?? "https://data.swift.org/swift-evolution/proposals"
    }
    func markdownBaseURL(_ link: String) -> String {
        let base = configuration[Keys.markdownBaseURL.rawValue] as? String ?? "https://raw.githubusercontent.com/apple/swift-evolution/master/proposals/"
        return base + link
    }
    func proposalBaseURL(_ link: String) -> String {
        let base = configuration[Keys.proposalBaseURL.rawValue] as? String ?? "https://github.com/apple/swift-evolution/blob/master/proposals/"
        return base + link
    }
    func proposalDeepLink(_ id: String) -> String {
        let base = configuration[Keys.proposalDeepLink.rawValue] as? String ?? "evo://proposal/"
        return base + id
    }
    func profileDeepLink(_ username: String) -> String {
        let base = configuration[Keys.profileDeepLink.rawValue] as? String ?? "evo://username/"
        return base + username
    }

    // MARK: Common Utility Values

    var proposalRegex: String {
        return configuration[Keys.proposalRegex.rawValue] as? String ?? "SE-([0-9]+)"
    }
    var bugRegex: String {
        return configuration[Keys.bugRegex.rawValue] as? String ?? "SR-([0-9]+)"
    }

}
