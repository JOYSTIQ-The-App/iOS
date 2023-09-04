//
//  Test.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/4/23.
//

import SwiftUI

struct CommentSectionView: View {
    
    let usernameArray = ["user1", "username2", "username123", "user4", "user5","username6","user7","governer","xeppa","user9"]
    
    let commentArray = ["This is the first comment", "This is the second comment", "Nice shot", "This is the fourth comment. This comment will be long. It's important to see how the view reacts to comments of varying lengths!", "lame", "This is the fifth comment","trash","Heres yet another long comment. The purpose of which is to diversify the comment section","Mid","Ahkay overwatt that wasnt bad!"]
    
    @Binding var showCommentSection: Bool
    @State private var isDragging = false
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        
        GeometryReader { geometry in
        
            VStack(spacing: 0) {
                
                Spacer()
                
                
                VStack(spacing: 0) {
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: UIScreen.main.bounds.width * 0.1, height: 4)
                        .foregroundColor(Color.gray)
                        .padding(.bottom, 10)
                    
                    Image("CommentsText3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.25, height: 20)
                    
                }
                .frame(width: UIScreen.main.bounds.width, height: 50)
                .background(Color("GradientDark"))
                .overlay(
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(width: UIScreen.main.bounds.width, height: 1),
                        alignment: .bottom
                        
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let yOffset = value.translation.height
                            if yOffset > 0 {
                                isDragging = true
                                dragOffset = yOffset
                            }
                        }
                        .onEnded { value in
                            let yOffset = value.translation.height
                            isDragging = false
                            if yOffset > geometry.size.height * 0.1 {
                                showCommentSection = false
                            }
                            dragOffset = 0
                        }
                )
                
                
                
                
                ScrollView(.vertical, showsIndicators: false) {
                
        
                    VStack(alignment: .leading) { //VStack for displaying comments
                        
                        ForEach(0..<10) { i in
                            // Comment section content
                            CommentView(userName: usernameArray[i], commentString: commentArray[i])
                            
                        }
                        
                    } //END VStack containing comments
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.top, 10)
                    
                    
                } //END Scrollview for comments
                .frame(height: geometry.size.height * 0.6)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("GradientDark"), Color("GradientDark")]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

 
         
                
                
                
            }
            
            
            
        } //end Geo reader
        .edgesIgnoringSafeArea(.all)
        .frame(maxHeight: .infinity)
        .offset(y: dragOffset)
        .background(Color.clear)
 

        
        
    }
}


struct Test_Previews: PreviewProvider {
    static var previews: some View {
        
        
        CommentSectionView(showCommentSection: .constant(true))
            
        
        
    }
}
