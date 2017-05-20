import Foundation

extension URLSession {
    public typealias ResponseBlock = (data: Data?, response: URLResponse?, error: Error?)
    
    open func request(_ url: String) -> ResponseBlock? {
        guard let url = URL(string: url)
            else {
                return nil
        }
        
        var data: Data?
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
