import Foundation

public extension SwiftPresso {
    
    enum UserData {
        
        public static var token: String? {
            guard let data = KeychainHelper.shared.read(
                service: .token,
                account: Preferences.keychainKey
            ) else {
                return nil
            }
            return get(String.self, from: data)
        }
        
        public static var id: Int? {
            guard let data = KeychainHelper.shared.read(
                service: .user,
                account: Preferences.keychainKey
            ) else {
                return nil
            }
            return get(Int.self, from: data)
        }
        
    }
    
}
