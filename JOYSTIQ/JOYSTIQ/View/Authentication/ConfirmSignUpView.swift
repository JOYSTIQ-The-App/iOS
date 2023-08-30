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
        
            
            VStack { //VStack for main container
                
                Spacer()
            
                Image("JS_Logo2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
            
                
                VStack(alignment: .center) {
                    
                    TextField(
                        "",
                        text: $confirmationCode
                    )
                    .placeholder(when: confirmationCode.isEmpty) {
                        Text("Confirmation Code").foregroundColor(.gray)
                    }
                    .padding(.all, 15.0)
                    .foregroundColor(.green)
                    .background(Color("Black1"))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .border(Color(UIColor.separator))
                    
                    HStack{
                        
                        Button("Confirm") {
                            
                            Task {
                                authService.isConfirmed = await authService.confirmSignUp(for: username, with: confirmationCode)
                            }
                            
                        }
                        .buttonStyle(DarkeningButtonStyle())
                        
                    } //END Hstack with confirm button
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
        
            
        
    } //END Body
}

struct ConfirmSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmSignUpView(username: "SampleUsername").environmentObject(AuthService())
    }
}

