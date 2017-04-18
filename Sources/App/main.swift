import Vapor

let drop = Droplet()

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.group("share") { share in
    share.get("proposal", String.self) { request, value in
        guard let id: Int = value.regex(Config.Common.Regex.proposalID) else {
            throw Abort.badRequest
        }
        
        if let json = try drop.client.get("https://data.swift.org/swift-evolution/proposals").json, let proposals = json.array {
            guard let index = proposals.flatMap({ $0.object?["id"] }).index(where: { $0.string == value }) else {
                throw Abort.notFound
            }
            
            let proposal = proposals[index]
            guard let object = proposal.object,
                let id = object["id"]?.string,
                let title = object["title"]?.string,
                let link = object["link"]?.string,
                let summary = object["summary"]?.string
            else {
                throw Abort.badRequest
            }
            
            print("Proposal: \(id) - \(title)".trimmingCharacters(in: .whitespacesAndNewlines))
        
            return try drop.view.make("share_index", [
                "id": value.trim(),
                "title": title.trim(),
                "description": summary.trim(),
                "proposal": "evo://proposal/\(value)",
                "link": "https://github.com/apple/swift-evolution/blob/master/proposals/\(link)"
                ])
        }
        
        throw Abort.notFound
    }
    
    share.get("profile", String.self) { request, profile in
        return "Profile: github.com/\(profile)"
    }
}

//drop.resource("posts", PostController())


drop.run()


