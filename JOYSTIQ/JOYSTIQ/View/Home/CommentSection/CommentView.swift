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
  
        HStack() { //HStack for username + comment string
            
            VStack { //for avatar image
                
                Image("TestAvatar4")
                    .frame(width: 45, height: 45)
                    .scaleEffect(0.24)
                    .foregroundColor(.black)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                
                Spacer()
                
                
            } //END Vstack for avatar image
            
            
            
            VStack(alignment: .leading, spacing: 0) { //for username and comment
                
                Text(userName)
                    .foregroundColor(.black)
                
                
                Text(commentString)
                    .foregroundColor(.black)
                
                
                
                
            } //END VStack for username and comment
            
         

            Spacer()
            
        } //END HStack for comment
        .padding(.horizontal, 20)
        .frame(width: UIScreen.main.bounds.width)
        .frame(maxHeight: 100)
        
        
        
    }
    
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView()
    }
}
