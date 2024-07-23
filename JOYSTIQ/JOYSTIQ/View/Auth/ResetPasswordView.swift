//
//  ResetPasswordView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/1/23.
//

import SwiftUI
import Amplify

struct ResetPasswordView<AuthServiceType: AuthServiceProtocol & ObservableObject>: View {
    
    //handles logged state
    @EnvironmentObject var authService: AuthServiceType
    
    let username: String
    @State private var password: String = ""
    @State private var confirmpassword: String = ""
    @State private var confirmationCode: String = ""
    
    @State private var errorMessage: String? = nil
    
    @Binding var navigateToResetPassword: Bool
    @Binding var navigateToForgotPassword: Bool
    
    var body: some View {
        VStack { //VStack for main container
            
            Spacer()
            
            Image("JS_Logo2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment: .center)
            
            
            VStack(alignment: .center) { //VStack for entries and sign up button
                
                //USERNAME
                TextField(username, text: .constant(username))
                    .placeholder(when: username.isEmpty) {
                        Text("Username").foregroundColor(.white).opacity(0.4)
                    }
                    .padding(.all, 15.0)
                    .foregroundColor(.white)
                    .background(Color("LightGray").opacity(0.4))
                    .border(Color(UIColor.separator))
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .disabled(true)
                
                //PASSWORD
                SecureField (
                    "",
                    text: $password
                )
                .placeholder(when: password.isEmpty) {
                    Text("Password").foregroundColor(.white).opacity(0.4)
                }
                .padding(.all, 15.0)
                .foregroundColor(.white)
                .background(Color("LightGray").opacity(0.4))
                .border(Color(UIColor.separator))
                .cornerRadius(10)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                //CONFIRM PASSWORD
                SecureField (
                    "",
                    text: $confirmpassword
                )
                .placeholder(when: confirmpassword.isEmpty) {
                    Text("Confirm Password").foregroundColor(.white).opacity(0.4)
                }
                .padding(.all, 15.0)
                .foregroundColor(.white)
                .background(Color("LightGray").opacity(0.4))
                .border(Color(UIColor.separator))
                .cornerRadius(10)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                //CONFIRMATION CODE
                SecureField (
                    "",
                    text: $confirmationCode
                )
                .placeholder(when: confirmationCode.isEmpty) {
                    Text("Confirmation Code").foregroundColor(.white).opacity(0.4)
                }
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
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                }
                
                
                
                Button(action: {
                    
                    //If requirements are met, toggle nav to confirm
                    //valid/availble username, valid email, passwords match
                    Task {
                        if password == confirmpassword {
                            await authService.confirmResetPassword(username: username, newPassword: password, confirmationCode: confirmationCode) { isSuccess in
                                if isSuccess {
                                    navigateToResetPassword.toggle()
                                    navigateToForgotPassword.toggle()
                                }
                            }
                        } else {
                            errorMessage = "Passwords do not match."
                        }   
                    }
                     
                    
                }, label: {
                    Text("Reset Password")
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
                .contentShape(Rectangle()) //makes entire frame tappable
                .padding(.top, 10)
                

                
            } //END VStack for entries and sign up button
            .padding(.all, 20.0)
            .padding(.bottom, 50)
            
            
            Spacer()
            

            Image("SmallTitle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 110, height: 20, alignment: .center)
      
            
        } //END VStack for main container
        .padding(.bottom, 50)
        .edgesIgnoringSafeArea(.all)
        //.background(Color("Black0"))
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("GradientLight"), Color("GradientDark")]),
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        )
    } //END Body
}



struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView<MockAuthService>(username: "SampleUsername", navigateToResetPassword: .constant(false), navigateToForgotPassword: .constant(false))
            .environmentObject(MockAuthService())
    }
}

