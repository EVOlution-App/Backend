import Foundation
import Kitura
import LoggerAPI
import KituraStencil

final class LandingController {
    public static func index(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        Log.debug("GET - / route handler...")
        defer {
            next()
        }
        
        try response.render(Config.Common.Templates.landing.rawValue,
                            context: [:]).end()
    }
}
