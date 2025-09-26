import SwiftUI

@MainActor
protocol AuthorizationViewModel: ObservableObject {
    var userRole: UserRole { get set }
    var isSignInMode: Bool { get set }
    var isAuthFormPresented: Bool { get set }
    var authMethod: AuthMethod? { get set }
    var email: String { get set }
    var password: String { get set }
    
    func authorize()
}

struct AuthorizationView<ViewModel: AuthorizationViewModel>: View {
    
    // MARK: - Internal Properties
    
    @StateObject var viewModel: ViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
                    
            VStack {
                Spacer()
                        
                Text(AuthorizationStrings.appName)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Colors.textPrimary)
                    .font(.system(size: 48, weight: .semibold))
                        
                Spacer()
                
                authBlock
            }
        }
        .sheet(isPresented: $viewModel.isAuthFormPresented) {
            authForm
                .presentationDetents([.medium])
        }
    }
    
    // MARK: - Private Views
    
    private var authBlock: some View {
        VStack {
            VStack(spacing: 15) {
                roleSegmentPicker
                
                mailButton
                googleButton
                anonimouslyButton
            }
            
            HStack(spacing: 4) {
                Text(viewModel.isSignInMode
                     ? AuthorizationStrings.noAccount
                     : AuthorizationStrings.alreadyHaveAccount)
                .fontWeight(.semibold)
                .foregroundStyle(Colors.textPrimary)
                
                Text(viewModel.isSignInMode
                     ? AuthorizationStrings.signUp
                     : AuthorizationStrings.signIn)
                .fontWeight(.semibold)
                .foregroundStyle(Colors.accent)
            }
            .onTapGesture {
                viewModel.isSignInMode.toggle()
            }
            .padding(.vertical, 15)
        }
        .padding(.horizontal, 30)
    }
    
    private var roleSegmentPicker: some View {
        HStack(spacing: 0) {
            segmentButton(title: AuthorizationStrings.student, role: .student)
            segmentButton(title: AuthorizationStrings.teacher, role: .teacher)
        }
        .frame(height: 40)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Colors.buttonPrimary)
        )
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Colors.buttonStroke, lineWidth: 2)
        )
    }
    
    @ViewBuilder
    private func segmentButton(title: String, role: UserRole) -> some View {
        Button {
            viewModel.userRole = role
        } label: {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(
                    viewModel.userRole == role
                    ? Colors.textSecondary
                    : Colors.textPrimary
                )
                .background(
                    Group {
                        if viewModel.userRole == role {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Colors.accent)
                                .shadow(radius: 2)
                        }
                    }
                )
        }
    }
    
    private var mailButton: some View {
        MainActionButtonView(
            model: MainActionButtonView.Model(
                text: viewModel.isSignInMode ? AuthorizationStrings.signInWithMail : AuthorizationStrings.signUpWithMail,
                image: Images.LocalImages.mail,
                action: {
                    viewModel.authMethod = .mail
                    viewModel.isAuthFormPresented = true
                }
            )
        )
        .contentTransition(.interpolate)
        .animation(.easeIn(duration: 0.2), value: viewModel.isSignInMode)
    }
    
    private var googleButton: some View {
        MainActionButtonView(
            model: MainActionButtonView.Model(
                text: AuthorizationStrings.signInWithGoogle,
                image: Images.LocalImages.google,
                action: {
                    viewModel.authMethod = .google
                    viewModel.authorize()
                }
            )
        )
    }
    
    private var anonimouslyButton: some View {
        MainActionButtonView(
            model: MainActionButtonView.Model(
                text: AuthorizationStrings.signInAnonymous,
                image: Images.LocalImages.creeper,
                action: {
                    viewModel.authMethod = .anonymous
                    viewModel.authorize()
                }
            )
        )
    }
    
    private var authForm: some View {
        VStack(spacing: 16) {
            
            Text(viewModel.isSignInMode ? AuthorizationStrings.signInHint : AuthorizationStrings.signUpHint)
                .foregroundStyle(Colors.textPrimary)
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .semibold))
            
            Spacer()
            
            TextField(AuthorizationStrings.emailInputPlaceholder, text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .padding()
                .background(Colors.backgroundSecondary)
                .cornerRadius(10)
                .foregroundColor(Colors.textPrimary)
                .fontWeight(.semibold)
                        
            SecureField(AuthorizationStrings.passwordInputPlaceholder, text: $viewModel.password)
                .padding()
                .background(Colors.backgroundSecondary)
                .cornerRadius(10)
                .foregroundColor(Colors.textPrimary)
                .fontWeight(.semibold)
            
            Spacer()
            
            MainActionButtonView(model: MainActionButtonView.Model(
                text: viewModel.isSignInMode ? AuthorizationStrings.signIn : AuthorizationStrings.signUp,
                textAlignment: .center,
                action: viewModel.authorize
            ))
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 30)
        .background(LinearGradient.appBackgroundReverse)
    }
}
