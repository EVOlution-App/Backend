import Foundation
import Kitura
import LoggerAPI
import KituraStencil

extension Controller {
    func list(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
    }
    
    func getProposal(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        Log.debug("GET - /share/proposal/:proposal route handler...")
        
        guard
            let proposalID = request.parameters["proposal"]
            else {
                try response.status(.badRequest).end()
                return
        }
        
        let findProposal = { (response: RouterResponse, next: @escaping () -> Void) in
            guard let proposal = self.proposals.find(id: proposalID) else {
                try? response.status(.notFound).end()
                return
            }
            
            _ = try? response.render(Config.shared.templateShareProposal,
                                     context: proposal.serialize())

            // Cache proposal content
            let createdDate = self.proposalContentExpirations[proposal.markdownLink]
            if self.proposalContent[proposal.markdownLink] == nil || (createdDate != nil && createdDate!.isExpired(Config.shared.cacheTimeout)) {

                Service.getProposalText(proposal.markdownLink) { [unowned response, next] (error, proposalText) in

                    guard let proposalText = proposalText, error == nil else {
                        try? response.status(.internalServerError).end()
                        return
                    }
                    self.proposalContent[proposal.markdownLink] = proposalText
                    self.proposalContentExpirations[proposal.markdownLink] = Date()
                    next()
                }
            } else {
                next()
            }
            
        }

        // Use cached proposals if available
        if self.proposals.count > 0 && !self.proposalsExpiration.isExpired(Config.shared.cacheTimeout) {
            findProposal(response, next)
        } else {
            Service.getProposals { [unowned response, next] (error, proposals) in
                guard let proposals = proposals, error == nil else {
                    try? response.status(.internalServerError).end()
                    return
                }
                self.proposals = proposals
                self.proposalsExpiration = Date()
                findProposal(response, next)
            }
        }
    }
    
}
