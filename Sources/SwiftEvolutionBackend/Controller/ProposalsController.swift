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
        
        Service.getProposals { [unowned response, next] (error, proposals) in
            guard
                let proposals = proposals,
                error == nil
                else {
                    try? response.status(.internalServerError).end()
                    return
            }
            
            guard
                let proposal = proposals.find(id: proposalID)
                else {
                    try? response.status(.notFound).end()
                    return
            }
            
            _ = try? response.render(Config.Common.Templates.shareProposal.rawValue,
                                     context: proposal.serialize())
            next()
        }
    }
    
}
