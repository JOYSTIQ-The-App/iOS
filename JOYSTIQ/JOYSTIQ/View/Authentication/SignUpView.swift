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
    @State private var errorMessage: String? = nil
    
    var body: some View {
        
        NavigationView {
              
            
            if !navigateToConfirmSignUp {
                
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
                            Text("Username").foregroundColor(.white).opacity(0.4)
                        }
                        .padding(.all, 15.0)
                        .foregroundColor(.white)
                        .background(Color("LightGray").opacity(0.4))
                        .border(Color(UIColor.separator))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        
                        //EMAIL
                        TextField (
                            "",
                            text: $email
                        )
                        .placeholder(when: email.isEmpty) {
                            Text("Email").foregroundColor(.white).opacity(0.4)
                        }
                        .padding(.all, 15.0)
                        .foregroundColor(.white)
                        .background(Color("LightGray").opacity(0.4))
                        .border(Color(UIColor.separator))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        
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
                        
                        if let error = errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .padding(.top, 8)
                                .padding(.bottom, 8)
                        }
                        
                        
                        Button(action: {
                            
                            //If requirements are met, toggle nav to confirm
                            //valid/availble username, valid email, passwords match
                            Task {
                                if password == confirmpassword {
                                    // Attempt to sign up
                                    authService.isSignedUp = await authService.signUp(username: username, email: email, password: password)
                                    
                                    // Check if sign-up was successful and then toggle navigation
                                    if authService.isSignedUp {
                                        navigateToConfirmSignUp.toggle()
                                    }
                                } else {
                                    errorMessage = "Passwords do not match."
                                }
                                
                            }
                             
                            
                        }, label: {
                            Text("Sign Up")
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
                
                
            } //END if NOT navToConfirm
                 
            
            
            else { //Bool navToConfirm is true
                
                ConfirmSignUpView(username: username, navigateToConfirmSignUp: $navigateToConfirmSignUp).environmentObject(AuthService())
                            
   
            }
            
     
            
        } //END Nav view
        
    } //END Body
    
    
}



struct SignUpScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView().environmentObject(AuthService())
    }
}

