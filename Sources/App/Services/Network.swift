import Foundation
import KituraRequest

struct Service {

    /**
     Request all proposals from Swift Evolution from data.swift.org
     
     - returns: proposals list or nil
     */
    static func getProposals() -> [Proposal]? {
        let response = KituraRequest.get(Config.Common.URLBase.proposals)

        guard
            let data = response.data,
            let proposals = data.proposals(),
            response.error == nil else {
                return nil
        }
        
        return proposals
    }
}
