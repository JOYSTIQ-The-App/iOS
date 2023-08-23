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
            ZStack {
                Color("Black0")
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer()
                        .frame(height: 100.0)
                    
                    VStack(spacing: 10.0){
                        Image("JS_Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .center)
                    }
                    
                    VStack(alignment: .center){
                        TextField(
                            "",
                            text: $username
                        )
                        .placeholder(when: username.isEmpty) {
                            Text("Email").foregroundColor(.gray)
                        }
                        .padding(.all, 15.0)
                        .foregroundColor(.white)
                        .background(Color("LightGray"))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .border(Color(UIColor.separator))
                        
                        SecureField(
                            "",
                            text: $password
                        )
                        .placeholder(when: password.isEmpty) {
                            Text("Password").foregroundColor(.gray)
                        }
                        .padding(.all, 15.0)
                        .foregroundColor(.white)
                        .background(Color("LightGray"))
                        .border(Color(UIColor.separator))
                        
                        HStack{
                            Button("Forgot password?") {
                                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                            }
                            .foregroundColor(.gray)
                            .frame(width: 160.0, height: 30.0)
                            .cornerRadius(10)
                            
                            Button("Log in") {
                                Task {
                                    await authService.signIn(username: username, password: password)
                                }
                            }
                            .foregroundColor(.black)
                            .frame(width: 120.0, height: 50.0)
                            .background(Color("AccentColor"))
                            .cornerRadius(10)
                            
                        }
                        .padding(.vertical, 5.0)
                        .padding(.horizontal, 20.0)
                        
                    }
                    .padding(.all, 20.0)
                    
                    Spacer()
                        .frame(height: 200.0)
                    
                    VStack(spacing: 20.0){
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
                        
                        Text(/*@START_MENU_TOKEN@*/"JOYSTIQ"/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .light, design: .serif))
                            .italic()
                    }
                    .padding(.all, 20.0)

                }
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthService())
    }
}

