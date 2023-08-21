//
//  SwiftUIView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 6/27/23.
//

import SwiftUI

struct CommentSectionView: View {
  
    @Binding var showCommentSection: Bool
    @State private var commentText: String = ""
    
    let usernameArray = ["user1", "username2", "username123", "user4", "user5","username6","user7","governer","xeppa","user9"]
    
    let commentArray = ["This is the first comment", "This is the second comment", "Nice shot", "This is the fourth comment. This comment will be long. It's important to see how the view reacts to comments of varying lengths!", "lame", "This is the fifth comment","trash","Heres yet another long comment. The purpose of which is to diversify the comment section","Mid","Ahkay overwatt that wasnt bad!"]
    
        
    var body: some View {
            
        VStack { //VStack for: HStack for [title and close button] / ScrollView for comments / Hstack for input and send button
            
            
            HStack { //START Hstack for Menu Title and Close Button
                
                Spacer()
                
                Text("Comments")
                    .foregroundColor(.gray)
                    .font(.title3)
                    .padding(.leading, 50)
                    .padding(.top, 8)
                    
                
                Spacer()
                
                Button(action: {
                    showCommentSection.toggle()
                    
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 26, height: 26)
                        .foregroundColor(.green)
                        .padding(.trailing, 20)
                        .padding(.top, 7)
                    
                }
            } //END HStack with Title and Close button
            .frame(width: UIScreen.main.bounds.width, height: 35)
            
            
            
            ScrollView(.vertical, showsIndicators: false) {
                    
                VStack(alignment: .leading) { //VStack for displaying comments
                    
                    ForEach(0..<10) { i in
                        CommentView(userName: usernameArray[i], commentString: commentArray[i])
                        
                    }
                    
                } //END VStack containing comments
                .frame(width: UIScreen.main.bounds.width)
                .padding(.vertical, 10)
                
                
            } //END Scrollview for comments
            .background(Color("Black0"))
            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color("CustomGray")), alignment: .top)
            .overlay(Rectangle().frame(width: nil, height: 1).foregroundColor(Color("CustomGray")), alignment: .bottom)
            
            
            HStack { //HStack for text input and send button
                
                TextField(
                    "",
                    text: $commentText
                )
                .placeholder(when: commentText.isEmpty) {
                    Text("comment").foregroundColor(.gray)
                }
                .padding(.all, 10)
                .foregroundColor(.white)
                .background(Color("Gray1"))
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .border(Color("LightGray"))
                
                Button(action: {
                   //send comment
                    commentText = ""
                    
                }) {
                    Image(systemName: "arrow.forward.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.green)
                        
                    
                }
                
                
            } //END HStack for text input and send comment button
            .padding(.bottom, 35)
            .padding(.top, 10)
            .padding(.horizontal, 20)
            
            
           
            
        } //END Main Vstack with: Hstack for title and close / scrollview for comments / hstack for user comment
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.green), alignment: .top)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.55)
        .background(Color.black)
        .edgesIgnoringSafeArea(.bottom)
           
    }
    
}


struct CommentSectionView_Previews: PreviewProvider {
    
    static var previews: some View {
        CommentSectionView(showCommentSection: .constant(true))
    }
}

