//
//  UserBannerPostView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 5/4/23.
//
// Takes in profile picture (png), username (string), game name (string ?)
//

import SwiftUI

struct UserBannerPostView: View {
    
    @State public var intVal: Int
    
    var body: some View {
        
        HStack() { // HStack for username + banner and game title button
            
            ZStack(alignment: .leading) { //ZStack for user picture and username banner
                
                
                /*
                 DEFAULT Image
                 
                Image(systemName: "person") // Replace "profile_picture" with user avatar snapshot
                    .frame(width: 55, height: 55)
                    .font(.system(size: 40))
                    .foregroundColor(.black)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 3))
                    .background(Circle().foregroundColor(.green))
                    .zIndex(1)
                */
                
                Image("TestAvatar4")
                    .frame(width: 55, height: 55)
                    .scaleEffect(0.3)
                    .foregroundColor(.black)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .zIndex(1)
                
                    
                
                Text("Username")
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width * 0.35, height: 35)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white, Color.gray]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                    .cornerRadius(10)
                    .zIndex(0)
                    .padding(.leading, 30)
                    
          
            } //Zstack for user banner
            .frame(width: UIScreen.main.bounds.width * 0.44, height: 60)
            .padding(.leading, 13)
            

                 
            
            //Game title button that features logo of game
            Button(action: {
                // this button may bring users to specific game content
            }) {
                Image("Logo" + String(intVal))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .cornerRadius(10)
                    
            }
            
            
        } //END HStack for pfp + username banner + game title
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        .background(Color("GradientDark3"))
        
        
        
    } //END Body
    
}


struct UserBannerPostView_Previews: PreviewProvider {
    static var previews: some View {
        UserBannerPostView(intVal: 1)
    }
}

