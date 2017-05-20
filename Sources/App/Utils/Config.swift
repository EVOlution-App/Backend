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
        struct Regex {
            static var proposalID: String {
                return "SE-([0-9]+)"
            }
            
            static var bugID: String {
                return "SR-([0-9]+)"
            }
        }
    }
}
