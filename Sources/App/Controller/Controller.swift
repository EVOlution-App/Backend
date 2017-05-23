import Foundation
import Kitura

import SwiftyJSON
import LoggerAPI
import Configuration
import CloudFoundryEnv
import CloudFoundryConfig
import KituraStencil

public class Controller {
    public let router: Router
    
    public init() {
        // All web apps need a Router instance to define routes
        router = Router()
        
        // Configure Template and source folder
        router.viewsPath = Config.Server.Resources.templates
        router.add(templateEngine: StencilTemplateEngine())

        // Serve static content from "public"
        router.all("/", middleware: StaticFileServer(path: Config.Server.Resources.staticFiles))
        
        
        // MARK: /
        router.get("/") { (request, response, next) in
            Log.debug("GET - / route handler...")
            defer {
                next()
            }

            try response.render(Config.Common.Templates.landing.rawValue,
                                context: [:]).end()
        }
        
        // MARK: /share/proposal/:proposal
        router.get("/share/proposal/:proposal") { (request, response, next) in
            Log.debug("GET - /share/proposal/:proposal route handler...")
            defer {
                next()
            }
            
            guard
                let proposalID = request.parameters["proposal"]
                else {
                    try response.status(.badRequest).end()
                    return
            }
            
            guard
                let proposals = Service.getProposals()
                else {
                    try response.status(.internalServerError).end()
                    return
            }
            
            guard
                let proposal = proposals.find(id: proposalID)
                else {
                    try response.status(.notFound).end()
                    return
            }
            
            try response.render(Config.Common.Templates.shareProposal.rawValue,
                                context: proposal.serialize())
        }
    }
}

