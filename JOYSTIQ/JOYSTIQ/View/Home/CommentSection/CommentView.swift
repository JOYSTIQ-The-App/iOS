//
//  CommentView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 6/28/23.
//

import SwiftUI

struct CommentView: View {
    
    var userName = "Username123"
    var commentString = "This is a comment that is particularyl long and should spill into the next line and keeps going to the third"
    
    var body: some View {
  
        HStack { //HStack for username + comment string
            
            VStack { //for avatar image
                
                Image("TestAvatar4")
                    .frame(width: 40, height: 40)
                    .scaleEffect(0.22)
                    .foregroundColor(.black)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                
                Spacer()
                
                
            } //END Vstack for avatar image
            
            
            VStack(alignment: .leading, spacing: 0) { //for username and comment
                
                Text(userName)
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                
                
                Text(commentString)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                
                
                
                
            } //END VStack for username and comment
            .padding(.bottom, 10)
            
         

            Spacer()
            
        } //END HStack for comment
        .padding(.horizontal, 20)
        .frame(width: UIScreen.main.bounds.width)
        
        
        
    }
    
}

/*
 
 Random color generator for testing avatar image strokes
 
func randomColor() -> Color {
    let colors: [Color] = [.white, .blue, .green, .red, .purple, .orange, .yellow]
    let randomIndex = Int.random(in: 0..<colors.count)
    return colors[randomIndex]
}
*/
struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView()
    }
}
