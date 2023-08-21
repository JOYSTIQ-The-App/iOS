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
        
        /*
        
        VStack(spacing: 0) { //VSTACK for drop down scroll view and triangle
            
            Triangle()
                .frame(width: 30, height: 20)
                .foregroundColor(.gray)
            //.padding(.top)
            
            
            
            VStack { //START VStack with [Menu/close] [feedback] [coffee]
                
                
                HStack { //START Hstack for Menu Title and Close Button
                    
                    Spacer()
                    
                    Text("JOYSTIQ Menu")
                        .foregroundColor(Color.black)
                        .font(.headline)
                        .padding(.leading, 50)
                    
                    Spacer()
                    
                    Button(action: {
                        showDropDown.toggle()
                        
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.green)
                            .padding()
                        
                    }
                } //END HStack with Title and Close button
                
                
                
                VStack(spacing: 0) {
                    
                    Text("We want your feedback! Let us know what changes you'd like to see.")
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.7)
                        .padding(.bottom, 20)
                    
                    
                    TextField("Enter feedback", text: $feedbacktext)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    
                    Button(action: {
                        // Action to perform on submit...
                        
                        //TO DO: Dont allow submit if empty
                        
                        feedbacktext = ""
                        showDropDown.toggle()
                        
                        
                        
                    }) {
                        Text("Submit")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .padding(.top, 15)
                    }
                    
                    
                }
                
                
                Divider() //Create line to seperate feedback from coffee
                    .background(Color.black)
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                    .padding(.vertical, 30)
                
                
                VStack(){ //Start coffee vstack - Title + Button
                    
                    Text("Support the JOYSTIQ Team!")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding(.bottom, 20)
                    
                    Button(action: {
                        
                        if let url = URL(string: self.buymeacoffeeLink) {
                            UIApplication.shared.open(url)
                        }
                        
                        showDropDown.toggle()
                        
                    }) {
                        
                        Text("Buy Me a Coffee")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    
                    
                    Button(action: {
                        showDropDown.toggle()
                        
                    }) {
                        
                        ZStack { //ZStack for coffee button
                            
                            Image(systemName: "cup.and.saucer.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.brown)
                                .padding()
                                .zIndex(1)
                            
                            Circle()
                                .fill(Color.black)
                                .frame(width: 90, height: 90)
                            
                        } //END Zstack for coffee button
                        
                        
                    } //END Button
                    
                    
                } //END coffee VStack for title and button
                
                
                
                Spacer() //Push elements up - maybe delete after.
                
                
                
            } //END Vstack with [ title / close button ] & [text box / submit button]
            .frame(height: UIScreen.main.bounds.height * 0.6)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
            .background(Color.gray)
            .cornerRadius(15)
            
            Spacer()
            
            
        } //END main vstack with modal view and triangle
        .padding(.top, 60)
        
        
        */
        
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
                            .foregroundColor(.gray)
                            //.frame(width: UIScreen.main.bounds.width * 0.7)
                            .multilineTextAlignment(.center)
                            .lineLimit(2) // Set the maximum number of lines to 1
                            .minimumScaleFactor(0.5)
                            .padding(.bottom, 20)
                        
                        
                        TextField("Enter feedback", text: $feedbacktext)
                            .padding()
                            .background(Color.white.opacity(0.5))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        
                        
                        Button(action: {
                            // Action to perform on submit...
                            
                            //TO DO: Dont allow submit if empty
                            
                            feedbacktext = ""
                            showDropDown.toggle()
                            
                            
                            
                        }) {
                            Text("Submit")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .padding(.top, 15)
                        }
                              
                          
                        
                    } //end vstack for feedback
                    .frame(width: UIScreen.main.bounds.width * 0.65)
                    .padding()
                    .background(Color("Black1"))
                    .cornerRadius(15)
                    
                    
                    
                    VStack(){ //Start coffee vstack
                        
                        Text("Support the JOYSTIQ Team!")
                            .foregroundColor(.gray)
                            .font(.headline)
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
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.brown)
                                    .padding()
                                    .zIndex(1)
                                
                                Circle()
                                    .fill(Color("Black3"))
                                    .frame(width: 90, height: 90)
                                
                            } //end Zstack for coffee button
                            
                        }
                        
                        
                        
                        
                    } //END coffee VStack
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                    .padding(.top, 20)
                    
                    Spacer()
                    
         
                    Button("Close") {
                        showDropDown.toggle()
                    }
                    .foregroundColor(.gray)
                    .frame(width: 100.0, height: 30.0)
                    .cornerRadius(10)
                    
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .offset(y: 10)
                    
                    
                    
                    
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

