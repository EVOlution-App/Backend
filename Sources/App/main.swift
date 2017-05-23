import Foundation
import Kitura
import LoggerAPI
import HeliumLogger

// HeliumLogger disables all buffering on stdout
HeliumLogger.use(LoggerMessageType.info)

let controller = Controller()
Log.info("Server will be started on '\(Config.Server.shared.url)'.")

Kitura.addHTTPServer(onPort: Config.Server.shared.port, with: controller.router)

// Start server
Kitura.run()
