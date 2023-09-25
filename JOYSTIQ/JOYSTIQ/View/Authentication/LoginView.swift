//
//  LoginView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 4/28/23.
//

import SwiftUI
import Amplify

struct LoginView<AuthServiceType: AuthServiceProtocol & ObservableObject>: View {
    
    //handles logged state
    @EnvironmentObject var authService: AuthServiceType
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isSignUpButtonTapped: Bool = false
    @State private var navigateToConfirmSignUp = false
    @State private var navigateToForgotPassword = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        
        NavigationView {
            
            VStack { //container for all stacks
                
                Spacer()
                
                Image("JS_Logo2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                
                
                VStack(alignment: .center) { //VStack for username / pass / hstack [forgot / login]
                    
                    TextField(
                        "Username",
                        text: $username
                    )
                    .padding(.all, 15.0)
                    .foregroundColor(.white)
                    .background(Color("LightGray").opacity(0.4))
                    .border(Color(UIColor.separator))
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    
                    
                    SecureField(
                        "Password",
                        text: $password
                    )
                    .padding(.all, 15.0)
                    .foregroundColor(.white)
                    .background(Color("LightGray").opacity(0.4))
                    .border(Color(UIColor.separator))
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding(.top, 8)
                            .padding(.bottom, 8)
                    }
                    
                    
                    VStack { //Hstack for login button and forgot pass
                        
                        //Login button
                        Button(action: {
                            Task {
                                await authService.signIn(username: username, password: password) { isSuccess, shouldNavigate in
                                    if isSuccess {
                                        navigateToConfirmSignUp = shouldNavigate
                                        errorMessage = nil
                                    } else {
                                        // Resetting the values if the login failed
                                        username = ""
                                        password = ""
                                        errorMessage = "Username or password does not exist."
                                    }
                                }
                            }
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
                        .contentShape(Rectangle()) // This makes the entire frame tappable
                        
                        NavigationLink("", destination: ConfirmSignUpView<AuthService>(username: username, navigateToConfirmSignUp: $navigateToConfirmSignUp), isActive: $navigateToConfirmSignUp)
                            .environmentObject(authService)


                        //Forgot password button
                        Button("Forgot password?") {
                            navigateToForgotPassword = true
                        }
                        .foregroundColor(Color("LightGray"))
                        .frame(width: 160, height: 30)
                        .cornerRadius(10)
                        
                        NavigationLink("", destination: ForgotPasswordView<AuthService>(navigateToForgotPassword: $navigateToForgotPassword), isActive: $navigateToForgotPassword)
                            .environmentObject(authService)
                        
                        
                    } //END HStack for forgot pass and login
                    .padding(.top, 10)
                    
                } //END VStack for username / pass / hstack [forgot / login]
                .padding(.all, 20)
                .padding(.bottom, 40)
                
                
                
                
                Spacer()

                
                
                
                VStack(spacing: 20.0) { //VStack for new acc button and logo text
                        
                    Button("Create new account") {
                        authService.signUpRequested = true
                    }
                    .foregroundColor(.white)
                    .frame(width: 300.0, height: 30.0)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    
                    NavigationLink("", destination: SignUpView<AuthService>(), isActive: $authService.signUpRequested)
                        .environmentObject(authService)
                    
                    
                    Image("SmallTitle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 110, height: 20, alignment: .center)
                    
                } //END VStack for new acc button and logo text
                .padding(.all, 20.0)
                .padding(.bottom, 30)
                
            } //end vstack for all elements
            .edgesIgnoringSafeArea(.vertical)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color("GradientLight"), Color("GradientDark")]),
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
            )
            
    

       } //end nav view
        
    } //end body
    
}




struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView<MockAuthService>()
            .environmentObject(MockAuthService())
    }
}
