import Foundation
import SwiftyJSON

public struct Proposal {
    var id: String
    var title: String
    var link: String
    var summary: String
    
    init?(_ dictionary: [String : JSON]) {
        guard
            let id      = dictionary["id"]?.string,
            let title   = dictionary["title"]?.string,
            let link    = dictionary["link"]?.string,
            let summary = dictionary["summary"]?.string
            else {
                return nil
        }
        
        self.id      = id
        self.title   = title
        self.link    = Config.Common.Proposal.URLBase.proposal(link)
        self.summary = summary
    }
    
    func serialize() -> [String: Any] {
        var result: [String: Any] = [:]
        
        result["id"]        = self.id
        result["title"]     = self.title
        result["link"]      = self.link
        result["summary"]   = self.summary
        result["proposal"]  = Config.Common.Proposal.Deeplink.proposal(self.id)
        
        return result
    }
}