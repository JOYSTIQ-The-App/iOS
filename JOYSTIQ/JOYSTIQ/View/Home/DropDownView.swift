//
//  DropDownView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 6/21/23.
//

import SwiftUI

struct DropDownView: View {
    
    @Binding var showDropDown: Bool
    @State private var feedbacktext = ""
    //used for preview
    @State private var AlwaysTrue = true
    
    let buymeacoffeeLink = "https://www.buymeacoffee.com/joystiq"

    var body: some View {
        
        VStack { //to push zstack to top
            
            ZStack { //for menu image and menu content
                
                Image("JSmenu3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.70)
                
                VStack { //for feedback vstack / coffee vstack / close
                    
                    
                    Divider() //Create line to seperate feedback from coffee
                        .background(Color.green)
                        .frame(width: UIScreen.main.bounds.width * 0.7)
                        .padding(.bottom, 20)
                    
                    
                    VStack { //for feedback
                        
                        Text("We want your feedback! What changes would you like to see?")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
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
                            
                            // Action to perform on submit...
                            
                            //TO DO: Dont allow submit if empty
                            
                            feedbacktext = ""
                            showDropDown.toggle()
                            
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
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                        
                        
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
                                    .foregroundColor(.green)
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
                            
                        }
                        
                        
                        
                        
                    } //END coffee VStack
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                    .padding(.top, 20)
                    
                    Spacer()
                    

                    
                    //Close button
                    Button(action: {
                        
                        showDropDown.toggle()
                        
                    }, label: {
                        
                        Text("Close")
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width * 0.30, height: 40)
                            .background(LinearGradient(
                                gradient: Gradient(colors: [Color("CustomGray"), Color.gray]),
                                            startPoint: .bottomLeading,
                                            endPoint: .topTrailing
                                        ))
                            .cornerRadius(30)
                    })
                    .contentShape(Rectangle()) // This makes the entire frame tappable
                    .padding(.top, 20)
                    .offset(y: 20)
                    
                    
                    
                    
                    
                } //end Vstack for feedback vstack / coffee vstack / close
                .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.55)
                .padding(.top, 30)
                
                
                
                     
            } //end Zstack with menu image and menu content
            
            
            Spacer()
            
            
        } //end vstack with zstack and spacer
        .padding(.top, UIScreen.main.bounds.height * 0.06)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
}


struct DropDownView_Previews: PreviewProvider {
    static var previews: some View {
        DropDownView(showDropDown: .constant(true))
    }
}

