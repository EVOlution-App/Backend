import Foundation
import SwiftyJSON

public struct Proposal {
    var id: String
    var title: String
    var link: String
    var markdownLink: String
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

        self.id           = id
        self.title        = title
        self.link         = Config.shared.proposalBaseURL(link)
        self.markdownLink = Config.shared.markdownBaseURL(link)
        self.summary      = summary
    }

    func serialize() -> [String: Any] {
        var result: [String: Any] = [:]

        result["id"]        = self.id
        result["title"]     = self.title
        result["link"]      = self.link
        result["summary"]   = self.summary
        result["proposal"]  = Config.shared.proposalDeepLink(self.id)

        return result
    }
}
