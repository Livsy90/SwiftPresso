import SwiftUI
import AuthenticationServices

public struct ProfileView<Content: View>: View {
    
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
    
    let bottomContent: () -> Content
    
    @State private var authKind = AuthKind.signIn
    @State private var isDeleteAlertPresented = false
    @FocusState private var isUsernameFocused
    @FocusState private var isPasswordFocused
    @FocusState private var isEmailFocused
    
    public var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    ZStack {
                        authView
                            .opacity(viewModel.mode == .auth ? 1 : 0)
                        profileView
                            .opacity(viewModel.mode == .profile ? 1 : 0)
                    }
                    
                    if viewModel.mode == .profile {
                        bottomContent()
                    }
                    
                    Button {
                        isDeleteAlertPresented = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                .background {
                    Rectangle()
                        .fill(Preferences.backgroundColor)
                        .ignoresSafeArea()
                }
                .alert(isPresented: $viewModel.error.boolValue()) {
                    Alert(title: Text(viewModel.error?.localizedDescription ?? ""))
                }
                .alert("Are you sure?", isPresented: $isDeleteAlertPresented, actions: {
                    Button("Yes") {
                        viewModel.onDelete()
                        isDeleteAlertPresented = false
                    }
                    
                    Button("No") {
                        isDeleteAlertPresented = false
                    }
                })
                .navigationTitle(viewModel.mode.title)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        if viewModel.mode == .profile {
                            Button("Exit") {
                                viewModel.onExit()
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .keyboard) {
                        HStack {
                            Spacer()
                            Button("Done") {
                                dismissKeyboard()
                            }
                        }
                    }
                }
                
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .overlay {
                        ProgressView()
                    }
                    .opacity(viewModel.isLoading ? 1 : 0)
            }
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
            
            Button {
                switch authKind {
                case .signIn:
                    viewModel.onSignIn()
                case .signUp:
                    viewModel.onSignUp()
                }
                dismissKeyboard()
            } label: {
                Text(authKind.text)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical)
        }
    }
    
    private var fields: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
                .focused($isUsernameFocused)
                .autocapitalization(.none)
                .font(.subheadline)
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                }
                .padding(.vertical)
            
            TextField("Password", text: $viewModel.password)
                .focused($isPasswordFocused)
                .autocapitalization(.none)
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
                    .focused($isEmailFocused)
                    .autocapitalization(.none)
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
    
    private func dismissKeyboard() {
        isUsernameFocused = false
        isEmailFocused = false
        isPasswordFocused = false
    }
    
}

extension ProfileView where Content == EmptyView {
    init() {
        self.bottomContent = {
            EmptyView()
        }
    }
}

#Preview {
    ProfileView()
}
