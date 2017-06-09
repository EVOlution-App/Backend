import Foundation
import Dispatch
import Kitura
import SwiftyJSON
import LoggerAPI
import Configuration
import CloudFoundryEnv
import CloudFoundryConfig
import KituraStencil

public class Controller {
    public let router: Router
    
    public var proposalCache = ProposalCache()
    public var proposalContentCache = [String: ProposalContent]()
    let proposalCacheSemaphore = DispatchSemaphore(value: 1)
    let proposalContentCacheSemaphore = DispatchSemaphore(value: 1)
    
    public init() {
        // All web apps need a Router instance to define routes
        router = Router()
        
        // Configure Template and source folder
        router.viewsPath = Config.shared.resourceTemplates
        router.add(templateEngine: StencilTemplateEngine())

        // Serve static content from "public"
        router.all("/", middleware: StaticFileServer(path: Config.shared.staticResourceFiles))
        
        // MARK: /
        router.get("/", handler: getLandingPage)
        
        // MARK: /share/proposal/:id
        router.get("/proposal/:id", handler: getProposal)
        
        // MARK: /share/proposalContent/:id
        router.get("/proposal/:id/markdown", handler: getProposalMarkdown)
        
        // MARK: /proposals
        router.get("/proposals", handler: getProposals)
    }
}

