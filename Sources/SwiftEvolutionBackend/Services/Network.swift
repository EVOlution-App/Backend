import Foundation

struct Service {

    public typealias CompletionProposalsHandler = (_ error: Error?, _ proposals: [Proposal]?) -> Swift.Void
    public typealias CompletionProposalHandler = (_ error: Error?, _ proposalText: String?) -> Swift.Void
    
    /**
     Request all proposals from Swift Evolution from data.swift.org
     
     - returns: proposals list or nil
     */
    static func getProposals(_ handler: @escaping CompletionProposalsHandler) {
        let session = URLSession(configuration: .default)

        if let url = URL(string: Config.shared.rawProposalsBaseURL) {
            let datatask = session.dataTask(with: url) { (data, _, error) in
                guard
                    let data = data,
                    let proposals = data.proposals(),
                    error == nil
                    else {
                        handler(error, nil)
                        return
                }

                handler(nil, proposals)
            }
                
            datatask.resume()
        }

    }
    
    static func getProposalText(_ proposalLink: String, handler: @escaping CompletionProposalHandler) {
        
        let session = URLSession(configuration: .default)
        
        if let url = URL(string: proposalLink) {
            
            let datatask = session.dataTask(with: url) { (data, _, error) in
                
                guard let data = data, let proposalText = data.proposalText(), error == nil else {
                    handler(error, nil)
                    return
                }
                handler(nil, proposalText)
            }
            datatask.resume()
        }
        
    }
}
