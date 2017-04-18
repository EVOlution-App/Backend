import Foundation

extension String {
    
    /**
     Trim left and right string to white spaces and new lines
     
     - returns: Trimmed string
     */
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /**
     Find the first Int based on Regular Expression
     
     - parameter pattern: regular expression to find an Int
     - returns: first Int found
     */
    func regex(_ pattern: String) -> Int? {
        guard let results: [Int] = self.regex(pattern) else {
            return nil
        }
        
        guard let item = results.first, results.count > 0 else {
            return nil
        }
        
        return item
    }
    
    /**
     Find a list of Int based on Regular Expression
     
     - parameter pattern: regular expression to find a list of Int
     - returns: list of Int found
     */
    func regex(_ pattern: String) -> [Int]? {
        guard let expression = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        
        let results = expression.matches(in: self, options: .reportCompletion, range: NSRange(location: 0, length: self.characters.count))
        
        let contents: [Int] = results.flatMap({
            let value = (self as NSString).substring(with: $0.rangeAt(1))
            return Int(value)
        })
        
        return contents
    }
}
