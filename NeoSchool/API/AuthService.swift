import Foundation

class AuthService {
    private let networkAPI = NetworkAPI()

    var userId: Int?

//    func refreshAccessToken(completion: @escaping (Bool) -> Void) async throws {
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

    func login(username: String, password: String, isTeacher: Bool, completion: @escaping (_ done: Bool) -> Void) async throws {
        do {
            let (refreshToken, accessToken) = try await networkAPI.login(username: username,
                                                                         password: password,
                                                                         isTeacher: isTeacher)
            if KeychainHelper.save(key: .refreshToken, data: refreshToken),
               KeychainHelper.save(key: .accessToken, data: accessToken) {
                DispatchQueue.main.async { completion(true) }
            }
        } catch {
            print(error)
            DispatchQueue.main.async { completion(false) }
        }
    }

    func sendResetPasswordCode(for email: String) async throws {
        self.userId = try await networkAPI.sendResetPasswordCode(for: email)
    }

    func checkResetPasswordCode(withCode code: Int) async throws -> Bool {
        guard let userId else { return false }
        return try await networkAPI.checkResetPasswordCode(userId: userId, code: code)
    }

    func updatePassword(with password: String, completion: @escaping () -> Void) async throws {
        try await networkAPI.updatePassword(with: password)
        completion()
    }

    func changePassword(from currentPassword: String, to newPassword: String, completion: @escaping (_ done: Bool) -> Void) async throws {
        do {
            try await networkAPI.changePassword(from: currentPassword, to: newPassword)
            DispatchQueue.main.async { completion(true) }
        } catch {
            DispatchQueue.main.async { completion(false) }
        }
    }

    func getProfileData() async throws -> ProfileInfo {
        let userProfile = try await networkAPI.getProfileData()
        return ProfileInfo(userProfile: userProfile)
    }
}
