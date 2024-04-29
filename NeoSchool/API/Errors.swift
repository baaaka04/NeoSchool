import Foundation

enum MyError: Error {
    case badNetwork
    
    var description: String {
        switch self {
        case .badNetwork:
            "Bad Network"
        }
    }
}
