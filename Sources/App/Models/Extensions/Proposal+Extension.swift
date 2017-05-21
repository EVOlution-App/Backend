import Foundation

extension Array where Iterator.Element == Proposal {
    
    /// Find proposal using its id
    /// it proposal couldn't be found on list, this function will return **nil**
    /// - parameter id: identification
    /// - returns: proposal object or nil
    func find(id: String) -> Proposal? {
        guard let index = self.map({ $0.id }).index(where: { $0 == id })
            else {
                return nil
        }
        
        return self[index]
    }
}
