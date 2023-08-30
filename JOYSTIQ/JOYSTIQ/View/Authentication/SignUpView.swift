//
//  SignUpScreenView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 6/7/23.
//

import SwiftUI
import Amplify

struct SignUpView: View {
    
    //handles logged state
    @EnvironmentObject var authService: AuthService
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmpassword: String = ""
    @State private var navigateToConfirmSignUp = false
    
    var body: some View {
        
        NavigationView {
        
            VStack { //VStack for main container
                
                Spacer()
                
                Image("JS_Logo2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                
                
                VStack(alignment: .center) { //VStack for entries and sign up button
                    
                    //USERNAME
                    TextField(
                        "",
                        text: $username
                    )
                    .placeholder(when: username.isEmpty) {
                        Text("Username").foregroundColor(.gray)
                    }
                    .padding(.all, 15.0)
                    .foregroundColor(.green)
                    .background(Color("Black1"))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .border(Color(UIColor.separator))
                    
                    //EMAIL
                    TextField (
                        "",
                        text: $email
                    )
                    .placeholder(when: email.isEmpty) {
                        Text("Email").foregroundColor(.gray)
                    }
                    .padding(.all, 15.0)
                    .foregroundColor(.green)
                    .background(Color("Black1"))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .border(Color(UIColor.separator))
                    
                    //PASSWORD
                    SecureField (
                        "",
                        text: $password
                    )
                    .placeholder(when: password.isEmpty) {
                        Text("Password").foregroundColor(.gray)
                    }
                    .padding(.all, 15.0)
                    .foregroundColor(.green)
                    .background(Color("Black1"))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .border(Color(UIColor.separator))
                    
                    //CONFIRM PASSWORD
                    SecureField (
                        "",
                        text: $confirmpassword
                    )
                    .placeholder(when: confirmpassword.isEmpty) {
                        Text("Confirm Password").foregroundColor(.gray)
                    }
                    .padding(.all, 15.0)
                    .foregroundColor(.green)
                    .background(Color("Black1"))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .border(Color(UIColor.separator))
                    
                    
                    //Nav Link & Sign up button
                    NavigationLink(destination: ConfirmSignUpView(username: username), isActive: $authService.isSignedUp) {
                        
                        Button("Sign Up") {
                            
                            //if Valid email, valid/available username, matching password
                            Task {
                                authService.isSignedUp = await authService.signUp(username: username, email: email, password: password)
                            }
                        }
                        .foregroundColor(.black)
                        .frame(width: 120.0, height: 50.0)
                        .background(Color("AccentColor"))
                        .cornerRadius(10)
                        .padding(.top, 10)
                    }
                    
                    
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
         
            
        } //END Nav view
        
    } //END Body
    
    
}



struct SignUpScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView().environmentObject(AuthService())
    }
}

