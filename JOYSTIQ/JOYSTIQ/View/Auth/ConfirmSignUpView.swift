//
//  ConfirmSignUpView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 6/7/23.
//

import SwiftUI
import Amplify

struct ConfirmSignUpView<AuthServiceType: AuthServiceProtocol & ObservableObject>: View {
    
    //handles logged state
    @EnvironmentObject var authService: AuthServiceType
    
    let email: String
    @State private var confirmationCode: String = ""
    @State private var navigateToNextView = false
    
    @Binding var navigateToConfirmSignUp: Bool
    
    var body: some View {
        
            
            VStack { //VStack for main container
                
                Spacer()
            
                Image("JS_Logo2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                
                
            
                
                VStack(alignment: .center) {
                    
                    Text("Check your email inbox for the confirmation code")
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray)
                    
                    TextField(
                        "",
                        text: $confirmationCode
                    )
                    .placeholder(when: confirmationCode.isEmpty, placeholder: {
                        Text("Confirmation Code").foregroundColor(.white).opacity(0.4)
                    })
                    .padding(.all, 15.0)
                    .foregroundColor(.white)
                    .background(Color("LightGray").opacity(0.4))
                    .border(Color(UIColor.separator))
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    
                   
                    HStack(spacing: 20) { //for cancel and confirm buttons
                        
                        //Resend button
                        Button(action: {
                            
                            Task {
                                await authService.resendConfirmationCode(for: email)
                            }
                            
                        }, label: {
                            
                            Text("Resend")
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width * 0.35, height: 50)
                                .background(LinearGradient(
                                    gradient: Gradient(colors: [Color.red, Color(red: 0.9, green: 0.3, blue: 0)]),
                                                startPoint: .topTrailing,
                                                endPoint: .bottomLeading
                                            ))
                                .cornerRadius(30)
                        })
                        .contentShape(Rectangle()) // This makes the entire frame tappable
                        .padding(.vertical, 20)
                        //END resend code button
                        

                        
                        //Confirm code button
                        Button(action: {
                            
                            Task {
                                authService.isConfirmed = await authService.confirmSignUp(for: email, with: confirmationCode)
                                
                                // Check if code confirmation was successful and then toggle navigation
                                if authService.isConfirmed {
                                    navigateToConfirmSignUp.toggle()
                                    
                                    // Pop this view off the stack, taking the user back to the login screen
                                    authService.isSignedUp = false
                                    authService.signUpRequested = false
                                }
                            }
                            
                        }, label: {
                            
                            Text("Confirm")
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width * 0.45, height: 50)
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
        
            
        
    } //END Body
}

struct ConfirmSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmSignUpView<MockAuthService>(email: "dev@joystiq.gg", navigateToConfirmSignUp: .constant(false))
            .environmentObject(MockAuthService())
    }
}

