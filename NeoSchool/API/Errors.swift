import Foundation

enum MyError: Error {
    case badNetwork, failDecoding, nothingToCancel
    
    var description: String {
        switch self {
        case .badNetwork:
            "Bad Network"
        case .failDecoding:
            "Could not decode data"
        case .nothingToCancel:
            "No submitted homework to cancel"
        }
    }
}
