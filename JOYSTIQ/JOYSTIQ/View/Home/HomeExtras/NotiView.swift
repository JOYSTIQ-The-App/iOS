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

            Text(notificationMessage)
                .font(.system(size: 16))
                .padding(.all, 15)
                .foregroundColor(.white)
                .lineLimit(3)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]),
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    ).opacity(0.8)
                )
                .cornerRadius(10)
                .padding(.leading, 5)

            Spacer()
            
            
            if notiType == "post" {
                
                ZStack {
                    
                    Image(systemName: "play.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .zIndex(1)
                    
                    Rectangle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color("LightGray").opacity(0.3))
                        .cornerRadius(10)
                        .zIndex(0)
            
                }
                .padding(.trailing, 5)
                
                    
                
                } else if notiType == "user" {
                    
                    ZStack {
                        
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .zIndex(1)
                        
                        Rectangle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color("LightGray").opacity(0.3))
                            .cornerRadius(10)
                            .zIndex(0)
                
                    }
                    .padding(.trailing, 5)
                    
                } else if notiType == "medal" {
                    
                    ZStack {
                        
                        Image("TrophyGold")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .zIndex(1)
                        
                        Rectangle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color("LightGray").opacity(0.3))
                            .cornerRadius(10)
                            .zIndex(0)
                
                    }
                    .padding(.trailing, 5)
                    
                    
       
                    
                }
            
            
            
        } //END HStack for notification
        .padding(.bottom, 10)
        .padding(.horizontal, 8)
        .frame(width: UIScreen.main.bounds.width)
        
    }
    
}

struct NotiView_Previews: PreviewProvider {
    static var previews: some View {
        NotiView(notificationMessage: "test test test test test test", notiType: "medal")
    }
}
