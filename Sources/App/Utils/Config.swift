struct Config {
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
