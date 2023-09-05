//
//  CommentSection2.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/5/23.
//

import SwiftUI

struct CommentSection2: View {
    
    let usernameArray = ["user1", "username2", "username123", "user4", "user5","username6","user7","governer","xeppa","user9"]
    
    let commentArray = ["This is the first comment", "This is the second comment", "Nice shot", "This is the fourth comment. This comment will be long. It's important to see how the view reacts to comments of varying lengths!", "lame", "This is the fifth comment","trash","Heres yet another long comment. The purpose of which is to diversify the comment section","Mid","Ahkay overwatt that wasnt bad!"]
    
    //@Binding var showCommentSection: Bool
    
    @State private var userComment: String = ""
    
    
    var body: some View {
        
            VStack(spacing: 0) {
                
                VStack { //for handlebar, title and divider
                    
                    Image("CommentsText3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.25, height: 20)
                        .padding(.top, 5)
                }
                .frame(width: UIScreen.main.bounds.width, height: 40)
                .background(Color("GradientDark"))
                .overlay(
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(width: UIScreen.main.bounds.width, height: 1),
                        alignment: .bottom
                        
                )
                
                
                

                
                ScrollView(.vertical, showsIndicators: false) {
                
        
                    VStack(alignment: .leading) { //VStack for displaying comments
                        
                        ForEach(0..<10) { i in
                            // Comment section content
                            CommentView(userName: usernameArray[i], commentString: commentArray[i])
                                .padding(.bottom, 5)
                            
                        }
                        
                    } //END VStack containing comments
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    
                    
                } //END Scrollview for comments
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("GradientDark"), Color("GradientDark")]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                

 
                HStack { //for user comment
                    
                    TextField(
                        "",
                        text: $userComment
                    )
                    .placeholder(when: userComment.isEmpty) {
                        Text("comment").foregroundColor(.white).opacity(0.4)
                    }
                    .padding(.all, 10)
                    .foregroundColor(.white)
                    .background(Color("LightGray").opacity(0.4))
                    .border(Color(UIColor.separator))
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    
                    Button(action: {
                       //send comment, reset textfield
                        userComment = ""
                        
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.green)
                            
                        
                    }
                    
                    
                    
                } //end hstack for user comment
                .padding(.horizontal, 20)
                .frame(height: 60)
                .background(Color("GradientDark"))
                .overlay(
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(width: UIScreen.main.bounds.width, height: 1),
                        alignment: .top
                        
                )
                
                
            } //END VStack for container
            
            
 

        
        
    }
    
}

/*

struct CommentSection2_Previews: PreviewProvider {
    static var previews: some View {
        CommentSection2(showCommentSection: .constant(true))
    }
}
*/
