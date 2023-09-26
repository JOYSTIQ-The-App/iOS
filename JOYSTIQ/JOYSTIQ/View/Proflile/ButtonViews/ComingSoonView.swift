//
//  ComingSoonView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/25/23.
//

import SwiftUI

struct ComingSoonView: View {
    
    @Binding var showComingSoon: Bool
    
    var body: some View {
        
        VStack(spacing: 0) { //VStack for main container
             
            Image("comingsoon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.5, height: 30, alignment: .center)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            
            HStack {
                
                Image(systemName: "network")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color("LightGray"))
                
                Text("Share your other socials!")
                    .font(.system(size: UIScreen.main.bounds.width * 0.045))
                    .foregroundColor(Color("LightGray"))
                
            }
            .padding(.top, UIScreen.main.bounds.height * 0.01)
            .padding(.bottom, 20)
            
            HStack {
                
                Image(systemName: "list.bullet.clipboard.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color("LightGray"))
                
                Text("Showcase your acheivements!")
                    .font(.system(size: UIScreen.main.bounds.width * 0.045))
                    .foregroundColor(Color("LightGray"))
        
            }
            
            
            
            
            
            
            Spacer()
            
            //Close button
            Button(action: {
                
                showComingSoon.toggle()
                
            }, label: {
                
                Text("Close")
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: UIScreen.main.bounds.width * 0.20, height: 40)
                    .background(.gray.opacity(0.8))
                    .cornerRadius(10)
            })
            .contentShape(Rectangle()) // This makes the entire frame tappable
            .padding(.bottom, 20)
            
            
            
            
        } //END main vstack container
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.3)
        .background(.black)
        .cornerRadius(10)
        .shadow(color: Color.green.opacity(0.5), radius: 5, x: 2, y: 2)
        .shadow(color: Color.green.opacity(0.5), radius: 5, x: -2, y: -2)
        .padding(.bottom, UIScreen.main.bounds.height * 0.2)
        
    } //end body
    
}

struct ComingSoonView_Previews: PreviewProvider {
    static var previews: some View {
        ComingSoonView(showComingSoon: .constant(true))
    }
}
