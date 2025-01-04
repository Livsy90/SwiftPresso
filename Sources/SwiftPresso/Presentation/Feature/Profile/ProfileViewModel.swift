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
            case .auth: "Authorization"
            case .profile: "Profile"
            }
        }
    }
    
    enum AuthKind: Int, CaseIterable {
        case signIn
        case signUp
        
        var text: String {
            switch self {
            case .signIn: "Sign In"
            case .signUp: "Sign Up"
            }
        }
    }
    
    var username: String = ""
    var password: String = ""
    var email: String = ""
    var error: Error?
    var mode: Mode = .auth
    var isLoading: Bool = false
    var authKind: AuthKind = .signIn
    var isAuthAvailable: Bool {
        validate()
    }
    
    private let authProvider: some AuthProviderProtocol = SwiftPresso.Provider.authProvider()
    private let userProvider: some UserProviderProtocol = SwiftPresso.Provider.userProvider()
    
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
                KeychainHelper.shared.save(
                    username,
                    service: .login,
                    account: Preferences.keychainKey
                )
                KeychainHelper.shared.save(
                    password,
                    service: .login,
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
            setDefaultAuthKind()
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
            setDefaultAuthKind()
        }
    }
    
    func onExit() {
        username.removeAll()
        password.removeAll()
        email.removeAll()
        withAnimation {
            mode = .auth
        }
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
            withAnimation {
                isLoading = true
            }
            do {
                let response = try await userProvider.delete(id: user.id)
                if response.isDeleted {
                    onExit()
                }
            } catch {
                self.error = error
            }
            withAnimation {
                isLoading = false
            }
            authKind = .signIn
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
    
    func validate() -> Bool {
        !username.isEmpty &&
        !password.isEmpty &&
        validateEmail()
    }
    
    func validateEmail() -> Bool {
        if authKind == .signUp {
            isValidEmail(email)
        } else {
            true
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func setDefaultAuthKind() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            authKind = .signIn
        }
    }
    
}
