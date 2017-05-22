import Configuration

/**
 Constant settings to use throughout the application
 */
struct Config {
    /**
     On Server struct there are configurations that will be used only on server instance
     */
    struct Server {
        private let configuration: ConfigurationManager
        
        static let shared = Server()
        
        init() {
            configuration = ConfigurationManager().load(.environmentVariables)
        }
        
        public var port: Int {
            return configuration.port
        }
        
        public var url: String {
            return configuration.url
        }
        
        struct Resources {
            static var templates: String {
                return  "./Resources/Templates/"
            }
            
            static var staticFiles: String {
                return "./Resources/public/"
            }
        }
    }
    
    struct Common {
        struct URLBase {
            static var proposals: String {
                return "https://data.swift.org/swift-evolution/proposals"
            }
        }
        
        enum Templates: String {
            case landing = "index.stencil"
            case shareProposal = "share_index.stencil"
        }
        
        struct Proposal {
            struct Regex {
                static var proposalID: String {
                    return "SE-([0-9]+)"
                }
                
                static var bugID: String {
                    return "SR-([0-9]+)"
                }
            }
            
            struct URLBase {
                static func markdown(_ link: String) -> String {
                    return "https://raw.githubusercontent.com/apple/swift-evolution/master/proposals/\(link)"
                }
                
                static func proposal(_ link: String) -> String {
                    return "https://github.com/apple/swift-evolution/blob/master/proposals/\(link)"
                }
            }
            
            struct Deeplink {
                static func proposal(_ id: String) -> String {
                    return "evo://proposal/\(id)"
                }
                
                static func profile(_ username: String) -> String {
                    return "evo://username/\(username)"
                }
            }
        }
    }
}
