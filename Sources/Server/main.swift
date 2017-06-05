import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import SwiftEvolutionBackend

// HeliumLogger disables all buffering on stdout
HeliumLogger.use(LoggerMessageType.info)

let controller = Controller()
Log.info("Server will be started on '\(Config.shared.url)'.")

Kitura.addHTTPServer(onPort: Config.shared.port, with: controller.router)

// Start server
Kitura.run()
