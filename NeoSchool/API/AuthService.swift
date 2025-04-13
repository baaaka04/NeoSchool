import Foundation

protocol AuthServiceProtocol {
    var userId: Int? { get set }

    func refreshAccessToken() async throws -> Bool
    func login(username: String, password: String, isTeacher: Bool) async throws -> Void
    func sendResetPasswordCode(for email: String) async throws -> Void
    func checkResetPasswordCode(withCode code: Int) async throws -> Bool
    func updatePassword(with password: String) async throws -> Void
    func changePassword(from currentPassword: String, to newPassword: String) async throws
    func getProfileData() async throws -> ProfileInfo
}

class AuthService: AuthServiceProtocol {
    private let networkAPI = NetworkAPI()

    var userId: Int?

    func refreshAccessToken() async throws -> Bool {
        guard let refreshTokenData = KeychainHelper.load(key: .refreshToken),
              let refreshToken = String(data: refreshTokenData, encoding: .utf8) else {
            return false
        }
        do {
            let newAccessToken = try await networkAPI.refreshAccessToken(refreshToken: refreshToken)
            _ = KeychainHelper.save(key: .accessToken, data: newAccessToken)
            return true
        } catch {
            return false
        }
    }

    func login(username: String, password: String, isTeacher: Bool) async throws {
        let (refreshToken, accessToken) = try await networkAPI
            .login(username: username, password: password, isTeacher: isTeacher)
        guard KeychainHelper.save(key: .refreshToken, data: refreshToken),
              KeychainHelper.save(key: .accessToken, data: accessToken) else {
            throw MyError.noRefreshToken
        }
    }

    func sendResetPasswordCode(for email: String) async throws {
        self.userId = try await networkAPI.sendResetPasswordCode(for: email)
    }

    func checkResetPasswordCode(withCode code: Int) async throws -> Bool {
        guard let userId else { return false }
        return try await networkAPI.checkResetPasswordCode(userId: userId, code: code)
    }

    func updatePassword(with password: String) async throws {
        try await networkAPI.updatePassword(with: password)
    }

    func changePassword(from currentPassword: String, to newPassword: String) async throws {
        try await networkAPI.changePassword(from: currentPassword, to: newPassword)
    }

    func getProfileData() async throws -> ProfileInfo {
        let userProfile = try await networkAPI.getProfileData()
        return ProfileInfo(userProfile: userProfile)
    }
}
