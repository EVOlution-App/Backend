import Foundation
import SwiftyJSON

extension Data {
    public func proposals() -> [Proposal]? {
        guard let list = JSON(data: self).array else {
            return nil
        }

        return list.flatMap { Proposal.init($0.dictionaryValue) }
    }
    
    public func proposalText() -> String? {
        if let content = String(data: self, encoding: .utf8) {
            return content
        }
        return nil
    }
}
