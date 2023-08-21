//
//  CommentView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 6/28/23.
//

import SwiftUI

struct CommentView: View {
    
    var userName = "Username123"
    var commentString = "This is a comment"
    
    var body: some View {
  
        HStack() { //HStack for username + comment string
            
            Text(userName + ": " + commentString)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .lineLimit(3)
                .padding(.all, 8)
                .background(Rectangle()
                    .foregroundColor(Color.black)
                    .border(Color("LightGray")))

            Spacer()
            
        } //END HStack for comment
        .padding(.bottom, 10)
        .frame(width: UIScreen.main.bounds.width - 30)
        
        
        
    }
    
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView()
    }
}
