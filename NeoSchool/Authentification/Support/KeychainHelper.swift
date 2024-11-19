import Foundation
import Security

enum Token: String {
    case accessToken, refreshToken
}

class KeychainHelper {
    static func save(key: Token, data: Data) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecValueData: data,
        ] as CFDictionary

        SecItemDelete(query)
        let status = SecItemAdd(query, nil)
        return status == errSecSuccess
    }

    static func load(key: Token) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne,
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        if status == errSecSuccess {
            return dataTypeRef as? Data
        }
        return nil
    }

    static func delete(key: Token) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
        ] as CFDictionary

        SecItemDelete(query)
    }
}
