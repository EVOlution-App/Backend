import Foundation
import Kitura
import KituraNet
import LoggerAPI
import KituraStencil
import Dispatch

extension Controller {
    
    // MARK: Get proposal

    func getProposal(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        Log.debug("GET - /proposal/:id route handler...")
        
        guard let proposalID = request.parameters["id"] else {
            try response.status(.badRequest).end()
            return
        }
        
        // Ensure we have proposal data and render a specific proposal
        processProposals(proposalID, response: response) { 
            self.renderProposal(proposalID, response: response, next: next)
        }
    }
    
    private func renderProposal(_ proposalID: String, response: RouterResponse, next: @escaping () -> Void) {
        guard let proposal = self.proposalCache.proposals.find(id: proposalID) else {
            try? response.status(.notFound).end()
            return
        }
        
        _ = try? response.render(Config.shared.templateShareProposal,
                                 context: proposal.serialize())
        next()
    }
    
    // MARK: Get proposal content
    
    func getProposalContent(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        Log.debug("GET - /proposalContent/:id route handler...")
        
        guard let proposalID = request.parameters["id"] else {
            try response.status(.badRequest).end()
            return
        }
        
        // Ensure we have proposal data and responsd with specific proposal markdown
        processProposals(proposalID, response: response) { 
            self.findProposal(proposalID, response: response, next: next)
        }
    }
    
    private func findProposal(_ proposalID: String, response: RouterResponse, next: @escaping () -> Void) {
        guard let proposal = self.proposalCache.proposals.find(id: proposalID) else {
            try? response.status(.notFound).end()
            return
        }
        
        // Cache proposal content
        let createdDate = self.proposalContent[proposal.markdownLink]?.expiration
        if self.proposalContent[proposal.markdownLink]?.content == nil || (createdDate != nil && createdDate!.isExpired(Config.shared.cacheTimeout)) {
            
            Service.getProposalText(proposal.markdownLink) { [unowned self, unowned response, next] (error, proposalText) in
                
                guard let proposalText = proposalText, error == nil else {
                    try? response.status(.internalServerError).end()
                    return
                }
                let proposalCache = ProposalContentCache(content: proposalText, expiration: Date())
                self.proposalContent[proposal.markdownLink] = proposalCache
                response.status(HTTPStatusCode.OK).send(proposalText)
                
                next()
            }
        } else if let cachedText = self.proposalContent[proposal.markdownLink]?.content {
            response.status(HTTPStatusCode.OK).send(cachedText)
            next()
        } else {
            next()
        }
    }
    
    // MARK: Proposal processing utilities
    
    private func processProposals(_ proposalID: String, response: RouterResponse, callback: @escaping () -> Void) {
        let semaphore = DispatchSemaphore(value: 1)
        semaphore.wait()
        
        if self.proposalCache.proposals.count > 0 && !self.proposalCache.expiration.isExpired(Config.shared.cacheTimeout) {
            semaphore.signal()
            callback()
        } else {
            Service.getProposals { [unowned self, unowned response] (error, proposals) in
                guard let proposals = proposals, error == nil else {
                    try? response.status(.internalServerError).end()
                    semaphore.signal()
                    return
                }
                self.proposalCache.proposals = proposals
                self.proposalCache.expiration = Date()
                semaphore.signal()
                callback()
            }
        }
    }
    
}
