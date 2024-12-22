import Observation
import Foundation
import SwiftUI

@Observable
@MainActor
final class ProfileViewModel {
    
    enum Mode {
        case auth
        case profile
    }
    
    var username: String = ""
    var password: String = ""
    var email: String = ""
    var error: Error?
    var mode: Mode = .auth
    var isLoading: Bool = false
    
    @ObservationIgnored
    private var authProvider: some AuthProviderProtocol = SwiftPresso.Provider.authProvider()
    @ObservationIgnored
    private var userProvider: some UserProviderProtocol = SwiftPresso.Provider.userProvider()
    
    init() {
        configureMode()
    }
    
    func onSignIn() {
        Task {
            withAnimation {
                isLoading = true
            }
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
                    userResponse,
                    service: .user,
                    account: Preferences.keychainKey
                )
                withAnimation {
                    mode = .profile
                }
            } catch {
                self.error = error
            }
            withAnimation {
                isLoading = false
            }
        }
    }
    
    func onSignUp() {
        Task {
            withAnimation {
                isLoading = true
            }
            do {
                let userResponse = try await userProvider.register(
                    username: username,
                    email: email,
                    password: password
                )
                KeychainHelper.shared.save(
                    userResponse,
                    service: .user,
                    account: Preferences.keychainKey
                )
                withAnimation {
                    mode = .profile
                }
            } catch {
                self.error = error
            }
            withAnimation {
                isLoading = false
            }
        }
    }
    
    func onExit() {
        username.removeAll()
        password.removeAll()
        email.removeAll()
        mode = .auth
        KeychainHelper.shared.delete(
            service: .token,
            account: Preferences.keychainKey
        )
        KeychainHelper.shared.delete(
            service: .user,
            account: Preferences.keychainKey
        )
    }
    
}

private extension ProfileViewModel {
    func configureMode() {
        if let data = KeychainHelper.shared.read(service: .user, account: Preferences.keychainKey) {
            let jsonDecoder = JSONDecoder()
            let user = try? jsonDecoder.decode(UserResponse.self, from: data)
            guard let user else {
                mode = .auth
                return
            }
            username = user.username
            mode = .profile
        } else {
            mode = .auth
        }
    }
}
