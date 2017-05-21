import Foundation

public typealias ResponseData = Data
public typealias ResponseBlock = (data: ResponseData?, response: URLResponse?, error: Error?)

extension URLSession {
    
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
