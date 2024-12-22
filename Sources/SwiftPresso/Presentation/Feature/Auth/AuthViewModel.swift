import Observation

@Observable
@MainActor
final class AuthViewModel {
    
    var username: String = ""
    var password: String = ""
    var email: String = ""
    var error: Error?
    
    @ObservationIgnored
    private var authProvider: some AuthProviderProtocol = SwiftPresso.Provider.authProvider()
    @ObservationIgnored
    private var userProvider: some UserProviderProtocol = SwiftPresso.Provider.userProvider()
    
    func onSignIn() {
        Task {
            do {
                let loginResponse = try await authProvider.login(
                    username: username,
                    password: password
                )
                KeychainHelper.shared.save(
                    loginResponse.token,
                    service: .token,
                    account: Preferences.keychainKey
                )
                
                let userResponse = try await authProvider.userInfo(
                    token: loginResponse.token
                )
                KeychainHelper.shared.save(
                    userResponse.id,
                    service: .userID,
                    account: Preferences.keychainKey
                )
            } catch {
                self.error = error
            }
        }
    }
    
    func onSignUp() {
        Task {
            do {
                let userResponse = try await userProvider.register(
                    username: username,
                    email: email,
                    password: password
                )
                KeychainHelper.shared.save(
                    userResponse.id,
                    service: .userID,
                    account: Preferences.keychainKey
                )
            } catch {
                self.error = error
            }
        }
    }
    
}
