import Configuration

struct Config {
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
    }
    
    struct Common {
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