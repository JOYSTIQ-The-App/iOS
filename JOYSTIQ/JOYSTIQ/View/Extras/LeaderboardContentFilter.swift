//
//  LeaderboardContentFilter.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 6/27/23.
//

import SwiftUI

struct LeaderboardContentFilter: View {
    
    @State private var isExpanded = false
    @State private var isForYouSelected = true
    
    var body: some View {
        
        ZStack(alignment: .trailing) {
            
            
            if isExpanded {
                HStack(spacing: 0) {
                    
                    
                    Text("Game title")
                        .onTapGesture {
                            isForYouSelected = true
                        }
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background(Color.green)
                        .foregroundColor(.black)
                   
                    Text("Content type")
                        .onTapGesture {
                            isForYouSelected = false
                        }
                        .padding(.trailing, 20)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background(Color.green)
                        .foregroundColor(.black)
                    
                    
                } //END Hstack for For You / Following
                .frame(width: UIScreen.main.bounds.width-20, height: 40)
                .padding(.leading, 20)
                .padding(.bottom, 10)
                .background(Color("Black0"))
                
            } //END Hstack if expanded
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 40)
                        .foregroundColor(.green)
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .rotationEffect(isExpanded ? .degrees(180) : .degrees(0))
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: 40)
            .offset(x: isExpanded ? -180 : 200, y: isExpanded ? -5 : 0)
            .animation(.spring())
           
            
        } //end main Zstack
        .padding(.top, isExpanded ? 0 : 6)
        
    }
}

struct LeaderboardContentFilter_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardContentFilter()
    }
}
