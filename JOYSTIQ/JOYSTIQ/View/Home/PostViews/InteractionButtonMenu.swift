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
                .padding(.trailing, 10)
                
            
            
            Button(action: {
                // Handle comment button action
                showCommentSection.toggle()
                
            }) {
                Image(systemName: "message")
                    .imageScale(.medium)
                    .foregroundColor(.white).opacity(0.8)
            }
            
            CommentCount(commentCount: Int.random(in: 100...1000))
            
            
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
                    .imageScale(.medium)
                    .padding(.trailing, 10)
                    .foregroundColor(.white).opacity(0.8)
                    
            }
   
            
            
        } //END Hstack for interaction buttons
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
        
    } //end body
    
}

struct InteractionButtonMenu_Previews: PreviewProvider {
    static var previews: some View {
        InteractionButtonMenu(showCommentSection: .constant(false), showingReportAlert: .constant(false))
            .background(Color("GradientDark3"))
    }
}
