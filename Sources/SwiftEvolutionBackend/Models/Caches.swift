
import Foundation

public struct ProposalCache {
    var proposals: [Proposal]
    var rawData: Data
    var expiration: Date
}

public struct ProposalContentCache {
    var content: String
    var expiration: Date
}
