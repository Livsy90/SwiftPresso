import SwiftUI
import AuthenticationServices

public struct ProfileView<Content: View>: View {
    
    @State private var viewModel = ProfileViewModel()
    
    let bottomContent: () -> Content
    
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
                        
                        Button("Delete Account", role: .destructive) {
                            isDeleteAlertPresented = true
                        }
                        .padding()
                        .padding(.bottom, 80)
                    }
                }
                .background {
                    Rectangle()
                        .fill(Preferences.backgroundColor)
                        .ignoresSafeArea()
                }
                .alert(isPresented: $viewModel.error.boolValue()) {
                    Alert(title: Text(viewModel.error?.localizedDescription ?? ""))
                }
                .alert("Are you sure?", isPresented: $isDeleteAlertPresented, actions: {
                    Button("Yes", role: .destructive) {
                        viewModel.onDelete()
                        isDeleteAlertPresented = false
                    }
                    
                    Button("Cancel", role: .cancel) {
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
        Picker("", selection: $viewModel.authKind) {
            ForEach(ProfileViewModel.AuthKind.allCases, id: \.self) { segment in
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
            fields
            
            Button {
                switch viewModel.authKind {
                case .signIn:
                    viewModel.onSignIn()
                case .signUp:
                    viewModel.onSignUp()
                }
                dismissKeyboard()
            } label: {
                Text(viewModel.authKind.text)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical)
            .disabled(!viewModel.isAuthAvailable)
        }
    }
    
    private var fields: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
                .focused($isUsernameFocused)
                .autocapitalization(.none)
                .font(.subheadline)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                }
                .padding(10)
            
            TextField("Password", text: $viewModel.password)
                .textContentType(.password)
                .focused($isPasswordFocused)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
                .font(.subheadline)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                }
                .padding(10)
            
            if case .signUp = viewModel.authKind {
                TextField("Email", text: $viewModel.email)
                    .focused($isEmailFocused)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    }
                    .padding(10)
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
