import Dispatch
import Foundation
import KituraNet
import KituraRequest

extension Request {
    public typealias CompletionResponse = (request: ClientRequest?, response: ClientResponse?, data: Data?, error: Swift.Error?)
}

extension KituraRequest {

    /**
     Request GET data from URL synchronously.
     
     _Example:_
     ```
     let res = KituraRequest.get("https://data.swift.org/swift-evolution/proposals")
     guard
        let data = res.data,
        let proposals = data.proposals(),
        res.error == nil else {
            return
     }
     ```
     
     - parameter URL: url to request
     - returns: (request: _ClientRequest?_, response: _ClientResponse?_, data: _Data?_, error: _Swift.Error?_)
     */
    public static func get(_ URL: String) -> Request.CompletionResponse {
        var req: ClientRequest?
        var res: ClientResponse?
        var data: Data?
        var error: Swift.Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        request(.get, URL).response {
            req   = $0
            res   = $1
            data  = $2
            error = $3
            
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (req, res, data, error)
    }
}
