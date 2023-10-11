//
//  InteractionButtonMenu.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 7/26/23.
//

import SwiftUI

struct SelfInteractionButtonMenu<APIServiceType: APIServiceProtocol>: View {
    
    @EnvironmentObject var user: User
    @Binding var showCommentSection: Bool
    var apiService: APIServiceType
    var postId: Int
    @State var likesCount: Int? = nil
    @State var commentCount: Int
    @State var userLiked: Bool
    
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        
        // Hstack for interaction buttons
        HStack {
            
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else {
                Button(action: {
                    isLoading = true
                    if userLiked {
                        likesCount? -= 1
                        
                        apiService.deleteLike(username: user.username, postId: postId) { result in
                            isLoading = false
                            switch result {
                            case .success:
                                userLiked.toggle()
                            case .failure(let error):
                                print("Error unliking post: \(error.localizedDescription)")
                            }
                        }
                    } else {
                        likesCount? += 1
                        apiService.createLike(username: user.username, postId: postId) { result in
                            isLoading = false
                            switch result {
                            case .success:
                                userLiked.toggle()
                            case .failure(let error):
                                print("Error liking post: \(error.localizedDescription)")
                            }
                        }
                    }
                }) {
                    LikeButton(isLiked: $userLiked, likesCount: $likesCount)
                }
                .disabled(isLoading)
                .padding(.trailing, 5)
            }
            
            CommentButton<APIService>(apiService: apiService, postId: postId, commentCount: commentCount)
                .onTapGesture {
                    showCommentSection.toggle()
                }
            
            Spacer()
            
            
        } //END Hstack for interaction buttons
        .padding(.horizontal, 25)
        .padding(.bottom, 8)
        
    } //end body
    
}

struct SelfInteractionButtonMenu_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "testUsername")
        
        return SelfInteractionButtonMenu<MockAPIService>(showCommentSection: .constant(false), apiService: MockAPIService(), postId: 1, likesCount: 1234, commentCount: 8, userLiked: true)
            .environmentObject(testUser)
            .background(Color("GradientDark3"))
    }
}
