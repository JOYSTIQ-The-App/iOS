//
//  ContentFilter.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 6/19/23.
//

import SwiftUI

struct ContentFilter: View {
    
    @State private var isExpanded = false
    @State private var isForYouSelected = true
    
    var body: some View {
        
        ZStack(alignment: .trailing) {
            
            
            if isExpanded {
                HStack(spacing: 0) {
                    
                    
                    Text("For You")
                        .onTapGesture {
                            isForYouSelected = true
                        }
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background(Color.green)
                        .foregroundColor(.black)
                        .overlay(Rectangle().frame(width: 70, height: 2, alignment: .bottom).foregroundColor(isForYouSelected ?  Color.black : Color.clear).offset(x: 10, y:-4), alignment: .bottom)
                   
                    Text("Following")
                        .onTapGesture {
                            isForYouSelected = false
                        }
                        .padding(.trailing, 20)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background(Color.green)
                        .foregroundColor(.black)
                        .overlay(Rectangle().frame(width: 80, height: 2, alignment: .bottom).foregroundColor(isForYouSelected ?  Color.clear : Color.black).offset(x: -10, y:-4), alignment: .bottom)
                    
                    
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

struct ContentFilter_Previews: PreviewProvider {
    static var previews: some View {
        ContentFilter()
    }
}
