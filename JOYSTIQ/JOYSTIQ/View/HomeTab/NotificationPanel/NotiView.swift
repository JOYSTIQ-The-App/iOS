//
//  NotiView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 6/29/23.
//

import SwiftUI

struct NotiView: View {
    
    let notificationMessage: String
    let notiType: String
    
    var body: some View {
        
        HStack() { //HStack for username + comment string

            
            if notiType == "post" {
                
                Image("TestAvatar4")
                    .frame(width: 40, height: 40)
                    .scaleEffect(0.2)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                
                Text(notificationMessage)
                    .font(.system(size: 14))
                    .padding(.leading, 5)
                    .foregroundColor(.white)
                    .lineLimit(3)
                
                Spacer()
                
                ZStack {
                    
                    Image(systemName: "play.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                        .zIndex(1)
                    
                    Rectangle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("LightGray").opacity(0.3))
                        .cornerRadius(10)
                        .zIndex(0)
            
                }
                .padding(.trailing, 5)
                
                    
                
                } else if notiType == "user" {
                    
                    Image("TestAvatar4")
                        .frame(width: 40, height: 40)
                        .scaleEffect(0.2)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    
                    Text(notificationMessage)
                        .font(.system(size: 14))
                        .padding(.leading, 5)
                        .foregroundColor(.white)
                        .lineLimit(3)
                    
                    Spacer()
                    
                    
      
                    
                } else if notiType == "medal" {
                    
                    ZStack {
                        
                        Image("TrophyGold")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .zIndex(1)
                        
                        Rectangle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color("LightGray").opacity(0.3))
                            .cornerRadius(10)
                            .zIndex(0)
                
                    }
                    
                    Text(notificationMessage)
                        .font(.system(size: 14))
                        .padding(.leading, 5)
                        .foregroundColor(.white)
                        .lineLimit(3)
                    
                    Spacer()
                    
                    
                }
            
            /*
            Text(notificationMessage)
                .font(.system(size: 14))
                .padding(.all, 10)
                .foregroundColor(.white)
                .lineLimit(3)
            
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("LightGray"), Color.gray]),
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    ).opacity(0.4)
                )
                .cornerRadius(10, corners: [.topRight, .bottomRight, .bottomLeft])
            */
            

            
            
            
        } //END HStack for notification
        .padding(.bottom, 5)
        .padding(.horizontal, 8)
        .frame(width: UIScreen.main.bounds.width)
        .overlay(Rectangle()
            .frame(width: UIScreen.main.bounds.width * 0.95, height: 1, alignment: .bottom)
            .foregroundColor(Color("LightGray").opacity(0.1)), alignment: .bottom)
        
    }
    
}

struct NotiView_Previews: PreviewProvider {
    static var previews: some View {
        NotiView(notificationMessage: "test test test test test test", notiType: "medal")
            .frame(width: UIScreen.main.bounds.width).background(Color("GradientDark"))
    }
}
