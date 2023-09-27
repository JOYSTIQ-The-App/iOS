//
//  InteractionButtonMenu.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 7/26/23.
//

import SwiftUI

struct InteractionButtonMenu<APIServiceType: APIServiceProtocol>: View {
    
    @EnvironmentObject var user: User
    @Binding var showCommentSection: Bool
    @Binding var showingReportAlert: Bool
    var APIService: APIServiceType
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
                        if let username = user.username {
                            APIService.deleteLike(username: username, postId: postId) { result in
                                isLoading = false
                                switch result {
                                case .success:
                                    userLiked.toggle()
                                case .failure(let error):
                                    print("Error unliking post: \(error.localizedDescription)")
                                }
                            }
                        }
                        
                    } else {
                        likesCount? += 1
                        if let username = user.username {
                            APIService.createLike(username: username, postId: postId) { result in
                                isLoading = false
                                switch result {
                                case .success:
                                    userLiked.toggle()
                                case .failure(let error):
                                    print("Error liking post: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }) {
                    LikeButton(isLiked: $userLiked, likesCount: $likesCount)
                }
                .disabled(isLoading)
                .padding(.trailing, 5)
            }
            
            CommentButton<APIService>(APIService: APIService, postId: postId, commentCount: commentCount)
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
        InteractionButtonMenu<MockAPIService>(showCommentSection: .constant(false), showingReportAlert: .constant(false), APIService: MockAPIService(), postId: 1, likesCount: 1234, commentCount: 8, userLiked: true)
            .environmentObject(User(username: "testUser"))
            .background(Color("GradientDark3"))
    }
}
