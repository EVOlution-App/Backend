/**

**/

import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import Controller

// HeliumLogger disables all buffering on stdout
HeliumLogger.use(LoggerMessageType.info)
let controller = Controller()
Log.info("Server will be started on '\(controller.url)'.")
Kitura.addHTTPServer(onPort: controller.port, with: controller.router)
// Start server
Kitura.run()
