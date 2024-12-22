import Observation
import Foundation
import SwiftUI

@Observable
@MainActor
final class ProfileViewModel {
    
    enum Mode {
        case auth
        case profile
        
        var title: String {
            switch self {
            case .auth:
                "Authorization"
            case .profile:
                "Profile"
            }
        }
    }
    
    var username: String = ""
    var password: String = ""
    var email: String = ""
    var error: Error?
    var mode: Mode = .auth
    var isLoading: Bool = false
    var isAuthAvailable: Bool {
        !username.isEmpty && !password.isEmpty && !email.isEmpty
    }
    
    @ObservationIgnored
    private var authProvider: some AuthProviderProtocol = SwiftPresso.Provider.authProvider()
    @ObservationIgnored
    private var userProvider: some UserProviderProtocol = SwiftPresso.Provider.userProvider()
    
    private var user: UserInfo? {
        guard let data = KeychainHelper.shared.read(
            service: .user,
            account: Preferences.keychainKey
        ) else {
            return nil
        }
        
        let jsonDecoder = JSONDecoder()
        let user = try? jsonDecoder.decode(UserInfo.self, from: data)
        
        return user
    }
    
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
    
    func onDelete() {
        Task {
            guard let user else { return }
            do {
                let response = try await userProvider.delete(id: user.id)
                if response.isDeleted {
                    onExit()
                }
            } catch {
                self.error = error
            }
        }
    }
    
}

private extension ProfileViewModel {
    func configureMode() {
        if let user {
            username = user.name
            mode = .profile
        } else {
            mode = .auth
        }
    }
    
    
}
