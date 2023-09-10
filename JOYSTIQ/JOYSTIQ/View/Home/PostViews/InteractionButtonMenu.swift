//
//  InteractionButtonMenu.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 7/26/23.
//

import SwiftUI

struct InteractionButtonMenu: View {
    
    @Binding var showCommentSection: Bool
    
    @Binding var showingReportAlert: Bool
    
    var body: some View {
        
        // Hstack for interaction buttons
        HStack {
            
            //pass post UUID to likebutton view
            LikeButton(likesCount: Int.random(in: 100...10000))
                .padding(.trailing, 5)
                
            
            CommentButton(commentCount: Int.random(in: 50...1000))
                .onTapGesture {
                    showCommentSection.toggle()
                }
            
            
            
            Spacer()
            
            
         
            Menu {
                
                Button(action: {
                    //report dialogue
                    showingReportAlert = true
                }) {
                    Text("Report Post")
                }
                
            } label: {
                
                Image(systemName: "flag")
                    .imageScale(.small)
                    .padding(.trailing, 10)
                    .foregroundColor(.white).opacity(0.7)
                    
            }
   
            
            
        } //END Hstack for interaction buttons
        .padding(.horizontal, 25)
        .padding(.bottom, 8)
        
    } //end body
    
}

struct InteractionButtonMenu_Previews: PreviewProvider {
    static var previews: some View {
        InteractionButtonMenu(showCommentSection: .constant(false), showingReportAlert: .constant(false))
            .background(Color("GradientDark3"))
    }
}
