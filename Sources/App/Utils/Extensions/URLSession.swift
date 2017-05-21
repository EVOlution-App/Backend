import Foundation

public typealias ResponseData = Data
public typealias ResponseBlock = (data: ResponseData?, response: URLResponse?, error: Error?)

extension URLSession {
    
    /**
     Request data from URL synchronously.
     
     _Example:_
     ```
     guard
        let res = URLSession.shared.request("https://data.swift.org/swift-evolution/proposals"),
        let data = res.data,
        let proposals = data.proposals(),
        res.error == nil else {
            return
     }
     ```
    - parameter url: url target
    - returns: (data: _ResponseData?_, response: _URLResponse?_, error: _Error?_)
    */
    func request(_ url: String) -> ResponseBlock? {
        guard let url = URL(string: url)
            else {
                return nil
        }
        
        var data: ResponseData?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        dataTask(with: url) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
}
