import Foundation

enum MyError: Error {
    case badNetwork, failDecoding, nothingToCancel, cannotEncodeData, noRefreshToken, noAccessToken, failSavingToken, noUserRole, invalidDateFormat

    var description: String {
        switch self {
        case .badNetwork:
            "Bad Network"
        case .failDecoding:
            "Could not decode data"
        case .nothingToCancel:
            "No submitted homework to cancel"
        case .cannotEncodeData:
            "Encoding data failed"
        case .noRefreshToken:
            "No refresh token"
        case .noAccessToken:
            "No access token"
        case .failSavingToken:
            "Fail saving a refresh or access token"
        case .noUserRole:
            "Fail getting user's type"
        case .invalidDateFormat:
            "Invalid Date Format"
        }
    }
}
