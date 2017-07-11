import Foundation

public struct ProposalCache {
    var proposals: [Proposal] = [Proposal]()
    var rawData: Data = Data()
    var expiration: Date = Date()
}

public struct ProposalContent {
    var content: String
    var expiration: Date
}
