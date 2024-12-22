import SwiftUI
import AuthenticationServices

public struct AuthView: View {
    
    @State private var viewModel = AuthViewModel()
    
    public enum AuthKind: Int, CaseIterable {
        case signIn
        case signUp
        
        var text: String {
            switch self {
            case .signIn: "Sign In"
            case .signUp: "Sign Up"
            }
        }
    }
    
    @State private var authKind = AuthKind.signIn
    
    public var body: some View {
        ScrollView {
            VStack {
                segmentedControl
                    .padding(.bottom, 30)
                authView
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
        .background {
            Rectangle()
                .fill(.ultraThickMaterial)
                .ignoresSafeArea()
        }
    }
    
    private var segmentedControl: some View {
        Picker("", selection: $authKind) {
            ForEach(AuthKind.allCases, id: \.self) { segment in
                Text(segment.text)
                    .tag(segment.rawValue)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var authView: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .padding()
            
            fields
            
            Button(authKind.text) {
                switch authKind {
                case .signIn:
                    viewModel.onSignIn()
                case .signUp:
                    viewModel.onSignUp()
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical)
        }
    }
    
    private var fields: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
                .font(.subheadline)
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                }
                .padding(.vertical)
            
            TextField("Password", text: $viewModel.password)
                .font(.subheadline)
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                }
                .padding(.vertical)
            
            if case .signUp = authKind {
                TextField("Email", text: $viewModel.email)
                    .font(.subheadline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    }
                    .padding(.vertical)
            }
        }
    }
    
}

#Preview {
    AuthView()
}
