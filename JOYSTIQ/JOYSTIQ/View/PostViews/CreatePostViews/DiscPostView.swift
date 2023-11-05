//
//  DiscussionPostView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 4/27/23.
//

import SwiftUI

struct DiscPostView: View {
    
    @State private var intValue: Int
    init(intValue: Int) {
        self._intValue = State(initialValue: intValue)
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
           
            // Banner
//            UserBannerPostView(userService: userService(), intVal: intValue)

            
            // Caption
            Text("This is a sample discussion post of a few lines of text. These posts will give users an oppertunity to share any news or opinions on games they love! Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                .font(.body)
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
            
            
            
            //top comment
            
            ZStack(alignment: .leading) {
                
                Image(systemName: "person")
                    .frame(width: 35, height: 30)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 3))
                    .background(Circle().foregroundColor(.blue))
                    .zIndex(1)
                    
                
                Text("This is the top comment!")
                    .offset(x: -5)
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .frame(width: 220, height: 30)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("LightGray"))
                        .opacity(0.8))
                    .zIndex(0)
                    .padding(.leading, 8)
          
            } //Zstack for top comment 1
            .frame(width: UIScreen.main.bounds.width-80, height: 10)
            .padding(.top, 30)
            .padding(.bottom, 20)
            .offset(x: -50)
            
            //2nd top comment
            ZStack(alignment: .leading) {
                
                Image(systemName: "person") // Replace "profile_picture" with your own image name
                    .frame(width: 35, height: 30)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 3))
                    .background(Circle().foregroundColor(.purple))
                    .zIndex(1)
                    
                
                Text("I am the second top comment")
                    .offset(x: 10)
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .frame(width: 220, height: 30)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("LightGray"))
                        .opacity(0.8))
                    .zIndex(0)
                    .padding(.leading, 8)
          
            } //Zstack for top comment 2
            .frame(width: UIScreen.main.bounds.width-80, height: 10)
            .padding(.top, 10)
            .padding(.bottom, 30)
            .offset(x: -50)
            
          
 
           
            
        } //end main Vstack for post
        .background(Color("Black0"))
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color("CustomGray")), alignment: .bottom)
        
        
    }
    
}

struct DiscPostView_Previews: PreviewProvider {
    static var previews: some View {
        DiscPostView(intValue: 1)
    }
}
