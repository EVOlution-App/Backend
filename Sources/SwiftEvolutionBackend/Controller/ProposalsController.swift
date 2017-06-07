import Foundation
import Kitura
import KituraNet
import LoggerAPI
import KituraStencil
import Dispatch

import SwiftyJSON

extension Controller {
    
    // MARK: Get proposal

    func getProposal(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        Log.debug("GET - /proposal/:id route handler...")
        
        guard let proposalID = request.parameters["id"] else {
            try response.status(.badRequest).end()
            return
        }
        
        // Ensure we have proposal data and render a specific proposal
        processProposals(response: response) {
            self.renderProposal(proposalID, response: response, next: next)
        }
    }
    
    private func renderProposal(_ proposalID: String, response: RouterResponse, next: @escaping () -> Void) {
        guard let proposal = self.proposalCache.proposals.find(id: proposalID) else {
            try? response.status(.notFound).end()
            return
        }
        
        response.headers.setType("html")
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
        processProposals(response: response) {
            self.findProposal(proposalID, response: response, next: next)
        }
    }
    
    private func findProposal(_ proposalID: String, response: RouterResponse, next: @escaping () -> Void) {
        guard let proposal = self.proposalCache.proposals.find(id: proposalID) else {
            try? response.status(.notFound).end()
            return
        }
        
        // Cache proposal content
        proposalContentCacheSemaphore.wait()
        response.headers.setType("text")
        let createdDate = self.proposalContentCache[proposal.markdownLink]?.expiration
        // TODO: remove ! if possible
        if self.proposalContentCache[proposal.markdownLink]?.content == nil || (createdDate != nil && createdDate!.isExpired(Config.shared.cacheTimeout)) {
            
            Service.getProposalText(proposal.markdownLink) { [unowned self, unowned response, next] (error, proposalText) in
                
                guard let proposalText = proposalText, error == nil else {
                    self.proposalContentCacheSemaphore.signal()
                    try? response.status(.internalServerError).end()
                    return
                }
                let proposalContent = ProposalContent(content: proposalText, expiration: Date())
                self.proposalContentCache[proposal.markdownLink] = proposalContent
                self.proposalContentCacheSemaphore.signal()
                response.status(HTTPStatusCode.OK).send(proposalText)
                next()
            }
        } else {
            if let cachedText = self.proposalContentCache[proposal.markdownLink]?.content {
                proposalContentCacheSemaphore.signal()
                response.status(HTTPStatusCode.OK).send(cachedText)
            } else {
                // This should never happen, but just in case.
                proposalContentCacheSemaphore.signal()
                try? response.status(.internalServerError).end()
            }
            next()
        }
    }
    
    // MARK: Get all proposals
    
    func getProposals(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        Log.debug("GET - /proposals route handler...")
        
        processProposals(response: response) {
            let json = JSON(data: self.proposalCache.rawData)
            response.status(.OK).send(json: json)
        }
    }
    
    // MARK: Proposal processing utilities
    
    private func processProposals(response: RouterResponse, callback: @escaping () -> Void) {
        
        proposalCacheSemaphore.wait()
        
        if self.proposalCache.proposals.count > 0 && !self.proposalCache.expiration.isExpired(Config.shared.cacheTimeout) {
            proposalCacheSemaphore.signal()
            callback()
        } else {
            Service.getProposals { [unowned self, unowned response] (error, data) in
                guard let data = data, let proposals = data.proposals(), error == nil else {
                    self.proposalCacheSemaphore.signal()
                    try? response.status(.internalServerError).end()
                    return
                }
                let latestCache = ProposalCache(proposals: proposals, rawData: data, expiration: Date())
                self.proposalCache = latestCache
                self.proposalCacheSemaphore.signal()
                callback()
            }
        }
    }
    
}
