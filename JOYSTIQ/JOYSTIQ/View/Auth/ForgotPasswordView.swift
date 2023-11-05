//
//  ForgotPasswordView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/1/23.
//


import SwiftUI
import Amplify

struct ForgotPasswordView<AuthServiceType: AuthServiceProtocol & ObservableObject>: View {
    
    //handles logged state
    @EnvironmentObject var authService: AuthServiceType
    
    @State private var username: String = ""
    @State private var navigateToResetPassword = false
    
    @Binding var navigateToForgotPassword: Bool
    
    var body: some View {
        
        NavigationView {
            
            if !navigateToResetPassword {
                
                VStack { //VStack for main container
                    
                    Spacer()
                
                    Image("JS_Logo2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                
                    
                    VStack(alignment: .center) {
                        
                        TextField(
                            "",
                            text: $username
                        )
                        .placeholder(when: username.isEmpty) {
                            Text("Email").foregroundColor(.white).opacity(0.4)
                        }
                        .padding(.all, 15.0)
                        .foregroundColor(.white)
                        .background(Color("LightGray").opacity(0.4))
                        .border(Color(UIColor.separator))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        
                       
                        HStack(spacing: 20) { //for cancel and confirm buttons
                            
                            //Confirm code button
                            Button(action: {
                                
                                Task {
                                    await authService.resetPassword(username: username) { isSuccess in
                                        if isSuccess {
                                            navigateToResetPassword.toggle()
                                            
                                            // Check if code confirmation was successful and then toggle navigation
                                            if authService.isConfirmed {
                                                // Pop this view off the stack, taking the user back to the login screen
                                                authService.isSignedUp = false
                                                authService.signUpRequested = false
                                            }
                                        }
                                    }
                                    
                                }
                                
                            }, label: {
                                
                                Text("Request Reset Password")
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 50)
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
                            .padding(.vertical, 20)
                            
                          //END Confirm code button
                            
                        }
                        
                        
                        
                        
                        
                    }
                    .padding(.all, 20.0)
                    
                    Spacer()
                    
                    Image("SmallTitle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 110, height: 20, alignment: .center)

                } //END VStack main container
                .padding(.bottom, 50)
                .edgesIgnoringSafeArea(.all)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("GradientLight"), Color("GradientDark")]),
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
                
            }
            
            else {
                ResetPasswordView<AuthService>(username: username, navigateToResetPassword: $navigateToResetPassword, navigateToForgotPassword: $navigateToForgotPassword)
                    .environmentObject(authService)
            }
            
        }
        
            
            
        
            
        
    } //END Body
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView<MockAuthService>(navigateToForgotPassword: .constant(false))
            .environmentObject(MockAuthService())
    }
}

