import Foundation


class AuthService {
    
    private let networkAPI = NetworkAPI()
    
    var userId: Int? = nil
    
    func refreshAccessToken(completion: @escaping (Bool) -> Void) async throws -> Void {
        guard let refreshTokenData = KeychainHelper.load(key: .refreshToken),
              let refreshToken = String(data: refreshTokenData, encoding: .utf8) else {
            completion(false)
            return
        }
        let newAccessToken = try await networkAPI.refreshAccessToken(refreshToken: refreshToken)
        KeychainHelper.save(key: .accessToken, data: newAccessToken)
        completion(true)
    }
    
    func login(username: String, password: String, isTeacher: Bool, completion: @escaping(_ done: Bool) -> Void) async throws -> Void {
        do {
            let (refreshToken, accessToken) = try await networkAPI.login(username: username, password: password, isTeacher: isTeacher)
            if KeychainHelper.save(key: .refreshToken, data: refreshToken),
               KeychainHelper.save(key: .accessToken, data: accessToken) {
                DispatchQueue.main.async { completion(true) }
            }
        } catch {
            print(error)
            DispatchQueue.main.async { completion(false) }
        }
    }
    
    func sendResetPasswordCode(for email: String) async throws -> Void {
        self.userId = try await networkAPI.sendResetPasswordCode(for: email)
    }
    
    func checkResetPasswordCode(withCode code: Int) async throws -> Bool {
        guard let userId else { return false }
        return try await networkAPI.checkResetPasswordCode(userId: userId, code: code)
    }
    
    func updatePassword(with password: String, completion: @escaping() -> Void) async throws -> Void {
        try await networkAPI.updatePassword(with: password)
        completion()
    }
    
    func getProfileData() async throws -> ProfileInfo {
        let userProfile = try await networkAPI.getProfileData()
        return ProfileInfo(userProfile: userProfile)
    }
}
