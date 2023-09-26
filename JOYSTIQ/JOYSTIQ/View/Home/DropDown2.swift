//
//  DropDown2.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/3/23.
//

import SwiftUI

struct DropDown2<FeedbackServiceType: FeedbackServiceProtocol>: View {
    var feedbackService: FeedbackServiceType
    
    @Binding var showDropDown: Bool
    @State private var feedbacktext = ""
    @State private var username = "Anonymous"
    
    
    
    let buymeacoffeeLink = "https://www.buymeacoffee.com/joystiq"
    
    
    
    var body: some View {
        
        
        
        VStack(spacing: 0) { //VSTACK for triangle and menu contents
            
            Triangle()
                .frame(width: 30, height: 15)
                .foregroundColor(Color.black)
            
            
            
            VStack { //START VStack with title [feedback], [coffee], close button
                
                Image("MenuText")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: 30, alignment: .center)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                
                VStack { //for feedback
                    
                    Text("We want your feedback! What changes would you like to see?")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2) // Set the maximum number of lines to 1
                        .minimumScaleFactor(0.5)
                        .padding(.bottom, 10)
                    
                    
                    TextField(
                        "",
                        text: $feedbacktext
                    )
                    .placeholder(when: feedbacktext.isEmpty) {
                        Text("Enter feedback").foregroundColor(.white).opacity(0.4)
                    }
                    .padding(.all, 15.0)
                    .foregroundColor(.white)
                    .background(Color("LightGray").opacity(0.4))
                    .border(Color(UIColor.separator))
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    
                    
                    //Submit feedback button
                    Button(action: {
                        
                        // Check if feedback text is not empty
                        if !feedbacktext.isEmpty {
                            // Username is currently "Anonymous"
                            feedbackService.sendFeedback(username: username, feedbackText: feedbacktext)
                            
                            feedbacktext = ""
                            showDropDown.toggle()
                        } else {
                            print("Feedback text cannot be empty.")
                        }
                        
                        feedbacktext = ""
                        
                    }, label: {
                        Text("Submit")
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width * 0.58, height: 50)
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
                    .padding(.top, 10)
                    
                    
                    
                } //end vstack for feedback
                .frame(width: UIScreen.main.bounds.width * 0.65)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("GradientLight"), Color("GradientDark")]),
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
                .cornerRadius(15)
                
                VStack(){ //Start coffee vstack
                    
                    Text("Support the JOYSTIQ Team!")
                        .foregroundColor(Color.white)
                        .padding(.bottom, 5)
                    
                    
                    Button(action: {
                        
                        if let url = URL(string: self.buymeacoffeeLink) {
                            UIApplication.shared.open(url)
                        }
                        
                        showDropDown.toggle()
                        
                    }) {
                        
                        /* Simple button
                         Text("Buy us Coffee")
                         .font(.headline)
                         .foregroundColor(.black)
                         .padding()
                         .background(Color.green)
                         .cornerRadius(10)
                         */
                        
                        
                        ZStack { //ZStack for coffee button
                            
                            Image(systemName: "cup.and.saucer.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 45, height: 45)
                                .foregroundColor(.brown)
                                .padding()
                                .zIndex(1)
                            
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color("GradientLight"), Color("GradientDark")]),
                                        startPoint: .topTrailing,
                                        endPoint: .bottomLeading
                                    )
                                )
                                .frame(width: 90, height: 90)
                            
                        } //end Zstack for coffee button
                        .padding(.bottom, 5)
                        
                    }
                    
                    
                } //END coffee VStack
                .frame(width: UIScreen.main.bounds.width * 0.58)
                .padding(.vertical, 10)
                .padding(.horizontal, 5)
                .background(
                    RadialGradient(
                        gradient: Gradient(colors: [Color("GradientDark2"), Color("GradientLight")]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 200
                    )
                )
                .cornerRadius(10)
                .padding(.top, 20)
                
                
                Spacer()
                
                
                //Close button
                Button(action: {
                    
                    showDropDown.toggle()
                    
                }, label: {
                    
                    Text("Close")
                        .foregroundColor(.white.opacity(0.8))
                        .frame(width: UIScreen.main.bounds.width * 0.20, height: 40)
                        .background(.gray.opacity(0.8))
                        .cornerRadius(10)
                })
                .contentShape(Rectangle()) // This makes the entire frame tappable
                .padding(.bottom, 20)
                
             
                
            } //end VStack for [feedback], [coffee], close
            .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.65)
            .background(.black)
            .cornerRadius(10)
  
            
            Spacer()
            
            
            
        } //END main vstack with modal view and triangle
        .padding(.top, UIScreen.main.bounds.height * 0.055)
        .shadow(color: Color.green.opacity(0.5), radius: 5, x: 2, y: 2)
        .shadow(color: Color.green.opacity(0.5), radius: 5, x: -2, y: -2)
        
        
        
        
    } //END Body
    
}

struct DropDown2_Previews: PreviewProvider {
    static var previews: some View {
        DropDown2(feedbackService: MockFeedbackService(), showDropDown: .constant(true))
        //.frame(width: UIScreen.main.bounds.width).background(.black)
    }
}
