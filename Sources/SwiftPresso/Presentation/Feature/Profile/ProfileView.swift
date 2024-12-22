import SwiftUI
import AuthenticationServices

public struct ProfileView: View {
    
    @State private var viewModel = ProfileViewModel()
    
    private enum AuthKind: Int, CaseIterable {
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
        NavigationStack {
            ScrollView {
                primaryView
                    .transition(.move(edge: .bottom))
            }
            .scrollDismissesKeyboard(.automatic)
            .background {
                Rectangle()
                    .fill(Preferences.backgroundColor)
                    .ignoresSafeArea()
            }
            .alert(isPresented: $viewModel.error.boolValue()) {
                Alert(title: Text(viewModel.error?.localizedDescription ?? ""))
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.mode == .profile {
                        Button("Exit") {
                            viewModel.onExit()
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.mode == .profile {
                        Button("More") {
                            
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var primaryView: some View {
        switch viewModel.mode {
        case .auth:
            authView
        case .profile:
            profileView
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
            segmentedControl
                .padding(.bottom, 30)
            authFormView
        }
        .padding()
    }
    
    private var authFormView: some View {
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
    
    private var profileView: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .padding()
            
            Text(viewModel.username)
                .font(.largeTitle)
                .fontWeight(.bold)
        }
    }
    
}

#Preview {
    ProfileView()
}
