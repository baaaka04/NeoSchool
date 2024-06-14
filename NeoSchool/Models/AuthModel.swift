import Foundation

struct ResetPasswordResponse: Codable {
    let message: String
    let userId: Int
}

struct VerifyPasswordResponse: Codable {
    let message: String
    let refresh: String
    let access: String
}
