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
    @State private var navigateToConfirmSignUp = false
    
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
                            Text("Username").foregroundColor(.gray)
                        }
                        .padding(.all, 15.0)
                        .foregroundColor(.white)
                        .background(Color("LightGray"))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .border(Color(UIColor.separator))
                        
                        TextField(
                            "",
                            text: $email
                        )
                        .placeholder(when: email.isEmpty) {
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
                            NavigationLink(destination: ConfirmSignUpView(username: username), isActive: $authService.isSignedUp) {
                                Button("Sign Up") {
                                    Task {
                                        authService.isSignedUp = await authService.signUp(username: username, email: email, password: password)
                                    }
                                }
                                .foregroundColor(.black)
                                .frame(width: 120.0, height: 50.0)
                                .background(Color("AccentColor"))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.vertical, 5.0)
                        .padding(.horizontal, 20.0)
                        
                    }
                    .padding(.all, 20.0)
                    
                    Spacer()
                        .frame(height: 200.0)
                    
                    VStack(spacing: 20.0){
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


struct SignUpScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView().environmentObject(AuthService())
    }
}

