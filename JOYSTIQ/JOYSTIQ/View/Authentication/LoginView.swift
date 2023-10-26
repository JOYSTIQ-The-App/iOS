//
//  LoginView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 4/28/23.
//

import SwiftUI
import Amplify

struct LoginView<AuthServiceType: AuthServiceProtocol & ObservableObject>: View {
    
    // MARK: - Properties

    @EnvironmentObject var authService: AuthServiceType
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUpButtonTapped: Bool = false
    @State private var navigateToConfirmSignUp = false
    @State private var navigateToForgotPassword = false
    @State private var errorMessage: String? = nil
    
    @State private var isLoading: Bool = false
    
    // MARK: - Body

    var body: some View {
        NavigationView {
            mainContentView
            .edgesIgnoringSafeArea(.vertical)
            .background(backgroundGradient)
        }
    }
    
    // MARK: - Subviews
    
    private var mainContentView: some View {
        VStack { // container for all stacks
            Spacer()
            logoImage
            credentialsForm
            Spacer()
            signUpSection
        }
    }
    
    private var logoImage: some View {
        Image("JS_Logo2")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100, alignment: .center)
    }
    
    private var credentialsForm: some View {
        VStack(alignment: .center) { // VStack for username / pass / HStack [forgot / login]
            emailTextField
            passwordField
            errorMessageView
            loginAndForgotButtons
        }
        .padding(.all, 20)
        .padding(.bottom, 40)
    }
    
    private var emailTextField: some View {
        TextField(
            "Email",
            text: $email
        )
        .textFieldStyle()
    }
    
    private var passwordField: some View {
        SecureField(
            "Password",
            text: $password
        )
        .textFieldStyle()
    }
    
    private var errorMessageView: some View {
        if let error = errorMessage {
            return AnyView(
                Text(error)
                    .foregroundColor(.red)
                    .padding(.vertical, 5)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    private var loginAndForgotButtons: some View {
        VStack {
            loginButton
            forgotPasswordButton
        }
        .padding(.top, 10)
    }

    private var loginButton: some View {
        Group {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5, anchor: .center)
            } else {
                Button(action: {
                    handleLoginAction()
                }, label: {
                    Text("Login")
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.65, height: 50)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]),
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            )
                        )
                        .cornerRadius(30)
                })
                .contentShape(Rectangle())
                .background(
                    NavigationLink(
                        "",
                        destination: ConfirmSignUpView<AuthService>(email: email, navigateToConfirmSignUp: $navigateToConfirmSignUp)
                    )
                    .environmentObject(authService)
                )
            }
        }
    }

    private var forgotPasswordButton: some View {
        Button("Forgot password?") {
            navigateToForgotPassword = true
        }
        .foregroundColor(Color("LightGray"))
        .frame(width: 160, height: 30)
        .cornerRadius(10)
        .background(
            NavigationLink(
                "",
                destination: ForgotPasswordView<AuthService>(navigateToForgotPassword: $navigateToForgotPassword),
                isActive: $navigateToForgotPassword
            )
            .environmentObject(authService)
        )
    }
    
    private var signUpSection: some View {
        VStack(spacing: 10.0) {
            createAccountButton
            smallTitleImage
        }
        .padding(.all, 20.0)
        .padding(.bottom, 30)
    }
    
    private var createAccountButton: some View {
        Button("Create new account") {
            authService.signUpRequested = true
        }
        .buttonStyle()
        .background(
            NavigationLink(
                "",
                destination: SignUpView<AuthService>()
                    .environmentObject(authService),
                isActive: $authService.signUpRequested
            )
        )
    }

    
    private var smallTitleImage: some View {
        Image("SmallTitle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 110, height: 20, alignment: .center)
    }
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color("GradientLight"), Color("GradientDark")]),
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
    }
    
    // MARK: - Functions
    
    private func handleLoginAction() {
        isLoading = true
        Task {
            await authService.signIn(email: email, password: password) { isSuccess, shouldNavigate in
                if isSuccess {
                    navigateToConfirmSignUp = shouldNavigate
                    errorMessage = nil
                    isLoading = false
                } else {
                    errorMessage = "Username or password does not exist."
                    isLoading = false
                }
            }
        }
    }

}

// MARK: - View Extensions

private extension View {
    func textFieldStyle() -> some View {
        self
            .padding(.all, 15.0)
            .foregroundColor(.white)
            .background(Color("LightGray").opacity(0.4))
            .border(Color(UIColor.separator))
            .cornerRadius(10)
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
    
    func buttonStyle() -> some View {
        self
            .foregroundColor(.white)
            .frame(width: 300.0, height: 30.0)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 2)
            )
    }
}

// MARK: - Previews

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView<MockAuthService>()
            .environmentObject(MockAuthService())
    }
}
