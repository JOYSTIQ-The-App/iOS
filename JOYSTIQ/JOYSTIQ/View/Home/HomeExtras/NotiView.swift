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
                .font(.system(size: 14))
                .padding(.all, 10)
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
                    
                    ZStack {
                        
                        Image(systemName: "person.circle")
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
                    .padding(.trailing, 5)
                    
                    
       
                    
                }
            
            
            
        } //END HStack for notification
        .padding(.bottom, 10)
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
    }
}
