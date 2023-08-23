//
//  ConfirmSignUpView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 6/7/23.
//

import SwiftUI
import Amplify

struct ConfirmSignUpView: View {
    
    //handles logged state
    @EnvironmentObject var authService: AuthService
    
    let username: String
    @State private var confirmationCode: String = ""
    @State private var navigateToNextView = false
    
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
                        text: $confirmationCode
                    )
                    .placeholder(when: confirmationCode.isEmpty) {
                        Text("Confirmation Code").foregroundColor(.gray)
                    }
                    .padding(.all, 15.0)
                    .foregroundColor(.white)
                    .background(Color("LightGray"))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .border(Color(UIColor.separator))
                    
                    HStack{
                        Button("Confirm") {
                            Task {
                                authService.isConfirmed = await authService.confirmSignUp(for: username, with: confirmationCode)
                            }
                        }
                        .foregroundColor(.black)
                        .frame(width: 120.0, height: 50.0)
                        .background(Color("AccentColor"))
                        .cornerRadius(10)
                        
                    }
                    .padding(.vertical, 5.0)
                    .padding(.horizontal, 20.0)
                    .onReceive(authService.$isConfirmed) { isConfirmed in
                        if isConfirmed {
                            // Pop this view off the stack, taking the user back to the login screen
                            authService.isSignedUp = false
                            authService.signUpRequested = false
                        }
                    }
                    
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

struct ConfirmSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmSignUpView(username: "SampleUsername").environmentObject(AuthService())
    }
}

