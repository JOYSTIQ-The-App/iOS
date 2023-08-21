//
//  LoginView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 4/28/23.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct LoginScreenView: View {
    
    //handles logged state
    @EnvironmentObject var userSession: UserSession
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
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
                    .background(Color("Gray1"))
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
                    .background(Color("Gray1"))
                    .border(Color(UIColor.separator))
                    
                    HStack{
                        Button("Forgot password?") {
                            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                        }
                        .foregroundColor(.gray)
                        .frame(width: 160.0, height: 30.0)
                        .cornerRadius(10)
                        
                        Button("Log in") {
                            
                            //validate user, then log them in
                            userSession.isLoggedIn = true
                            
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
                    Button("Create new account") {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    }
                    .foregroundColor(.white)
                    .frame(width: 300.0, height: 30.0)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    
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


struct LoginScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreenView()
    }
}

