//
//  LoginView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 4/28/23.
//

import SwiftUI
import Amplify

struct LoginView: View {
    
    //handles logged state
    @EnvironmentObject var authService: AuthService
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isSignUpButtonTapped: Bool = false
    
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
                        "",
                        text: $username
                    )
                    .placeholder(when: username.isEmpty) {
                        Text("Username").foregroundColor(.white).opacity(0.6)
                    }
                    .padding(.all, 15.0)
                    .foregroundColor(.black)
                    .background(Color("LightGray"))
                    .opacity(0.8)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .border(Color(UIColor.separator))
                    
                    SecureField(
                        "",
                        text: $password
                    )
                    .placeholder(when: password.isEmpty) {
                        Text("Password").foregroundColor(.white).opacity(0.6)
                    }
                    .padding(.all, 15.0)
                    .foregroundColor(.black)
                    .background(Color("LightGray"))
                    .opacity(0.8)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .border(Color(UIColor.separator))
                    
                    
                    
                    
                    VStack { //Hstack for forgot pass and login
                        
                        Button("Login") {
                            
                            Task {
                                await authService.signIn(username: username, password: password)
                            }
                            
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.7, height: 50)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]),
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            )
                        )
                        .cornerRadius(30)
                        
                        
                        
                        Button("Forgot password?") {
                            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                        }
                        .foregroundColor(Color("LightGray"))
                        .frame(width: 160, height: 30)
                        .cornerRadius(10)
                        .padding(.top, 10)
                        
                        
                    } //END HStack for forgot pass and login
                    .padding(.top, 10)
                    
                } //END VStack for username / pass / hstack [forgot / login]
                .padding(.all, 20)
                .padding(.bottom, 40)
                
                
                
                
                Spacer()

                
                
                
                VStack(spacing: 20.0) { //VStack for new acc button and logo text
                    
                    NavigationLink(destination: SignUpView(), isActive: $authService.signUpRequested) {
                        
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
                    }
                    
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
        LoginView().environmentObject(AuthService())
    }
}

