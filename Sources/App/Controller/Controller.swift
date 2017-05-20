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
            
            guard let proposalID = request.parameters["proposal"] else {
                try response.status(.notFound).end()
                return
            }
            
            guard
                let request = URLSession.shared.request("https://data.swift.org/swift-evolution/proposals"),
                let data    = request.data,
                request.error == nil else {
                    try response.status(.notFound).end()
                    return
            }
            
            guard let proposals = JSON(data: data).array else {
                return
            }
            
            guard
                let index       = proposals.flatMap({ $0["id"] }).index(where: { $0.string == proposalID }),
                let proposal    = proposals[index].dictionary else {
                    try response.status(.notFound).end()
                    return
            }
            
            guard
                let title   = proposal["title"]?.string,
                let link    = proposal["link"]?.string,
                let summary = proposal["summary"]?.string
                else {
                    return
            }
            
            let context = [
                "id"            : proposalID.trim(),
                "title"         : title.trim(),
                "description"   : summary.trim(),
                "proposal"      : "evo://proposal/\(proposalID.trim())",
                "link"          : "https://github.com/apple/swift-evolution/blob/master/proposals/\(link)"
            ]

            try response.render("share_index.stencil", context: context)
        }
    }
}
