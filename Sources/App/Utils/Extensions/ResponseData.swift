import Foundation
import SwiftyJSON

extension ResponseData {
    public func proposals() -> [Proposal]? {
        guard let list = JSON(data: self).array else {
            return nil
        }

        return list.flatMap { Proposal.init($0.dictionaryValue) }
    }
}
