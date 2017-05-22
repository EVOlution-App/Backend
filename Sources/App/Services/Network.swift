import Foundation

struct Service {

    /**
     Request all proposals from Swift Evolution from data.swift.org
     
     - returns: proposals list or nil
     */
    static func getProposals() -> [Proposal]? {
        guard
            let response = URLSession.shared.request(Config.Common.URLBase.proposals),
            let data = response.data,
            let proposals = data.proposals(),
            response.error == nil else {
                return nil
        }
        
        return proposals
    }
}
