import Foundation

extension String {

    /**
     Trim left and right string to white spaces and new lines
     
     - returns: Trimmed string
     */
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
