import Foundation
import Kitura
import KituraRequest

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
        router.viewsPath = "./Resources/Templates/"
        router.add(templateEngine: StencilTemplateEngine())
        
        
        // Serve static content from "public"
        router.all("/", middleware: StaticFileServer(path: "./Resources/public/"))
        
        
        // MARK: /
        router.get("/") { (request, response, next) in
            Log.debug("GET - / route handler...")
            defer {
                next()
            }

            try response.render("index.stencil", context: ["share": "it works"]).end()
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
                let res = URLSession.shared.request("https://data.swift.org/swift-evolution/proposals"),
                let data = res.data,
                let proposals = data.proposals(),
                res.error == nil else {
                    try response.status(.notFound).end()
                    return
            }
            
            guard
                let proposal = proposals.find(id: proposalID)
                else {
                    try response.status(.notFound).end()
                    return
            }
            
            try response.render("share_index.stencil",
                                context: proposal.serialize())
        }
    }
}

