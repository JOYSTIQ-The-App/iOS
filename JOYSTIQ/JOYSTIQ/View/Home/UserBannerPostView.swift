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
                
                Image(systemName: "person") // Replace "profile_picture" with user avatar snapshot
                    .frame(width: 65, height: 60)
                    .font(.system(size: 40))
                    .foregroundColor(.black)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 3))
                    .background(Circle().foregroundColor(.green))
                    .zIndex(1)
                    
                
                Text("Username")
                    .font(.title2)
                    .foregroundColor(.black)
                    .frame(width: 200, height: 40)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("LightGray"))
                        .opacity(0.8))
                    .zIndex(0)
                    .padding(.leading, 40)
          
            } //Zstack for user banner
            .frame(width: 260, height: 60)

                 
            
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
        .background(Color("Black0"))
        
        
        
    } //END Body
    
}


struct UserBannerPostView_Previews: PreviewProvider {
    static var previews: some View {
        UserBannerPostView(intVal: 1)
    }
}

