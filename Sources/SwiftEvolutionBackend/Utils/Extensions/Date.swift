import Foundation

extension Date {

    func isExpired(_ timeout: Int) -> Bool {

        let now = Date()
        let interval = Int(now.timeIntervalSince(self))
        return interval > timeout
    }

}
