import Foundation

enum MyError: Error {
    case badNetwork, failDecoding
    
    var description: String {
        switch self {
        case .badNetwork:
            "Bad Network"
        case .failDecoding:
            "Could not decode data"
        }
    }
}
