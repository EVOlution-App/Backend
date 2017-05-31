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
        router.get("/", handler: getLandingPage)
        
        // MARK: /share/proposal/:proposal
        router.get("/share/proposal/:proposal", handler: getProposal)
    }
}

