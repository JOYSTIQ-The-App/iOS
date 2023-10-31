//
//  InteractionButtonMenu.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 7/26/23.
//

import SwiftUI

struct SelfInteractionButtonMenu<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    @Binding var showCommentSection: Bool
    var apiService: APIServiceType
    var postId: Int
    @State var likesCount: Int? = nil
    @State var commentCount: Int
    @State var userLiked: Bool
    @State private var isLoading: Bool = false

    // MARK: - Body
    var body: some View {
        HStack {
            loadingOrButtonContent
//            CommentButton<APIService>(apiService: apiService, postId: postId, commentCount: commentCount)
//                .onTapGesture {
//                    print("Comment Section")
//                    showCommentSection.toggle()
//                }
            Spacer()
        }
        .padding(.horizontal, 25)
        .padding(.bottom, 8)
    }

    // MARK: - Subviews
    private var loadingOrButtonContent: some View {
        if isLoading {
            return AnyView(
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .green))
                    .scaleEffect(0.8)
                    .padding(.trailing, 5)
            )
        } else {
            return AnyView(
                Button(action: likeButtonAction) {
                    LikeButton(isLiked: $userLiked, likesCount: $likesCount)
                }
                .disabled(isLoading)
                .padding(.trailing, 5)
            )
        }
    }

    // MARK: - Functions
    private func likeButtonAction() {
        isLoading = true
        if userLiked {
            unlikePost()
        } else {
            likePost()
        }
    }

    private func likePost() {
//        likesCount? += 1
        apiService.createLike(username: user.username, postId: postId) { result in
            switch result {
            case .success:
                userLiked.toggle()
                isLoading = false
            case .failure(let error):
                print("Error liking post: \(error.localizedDescription)")
                isLoading = false
            }
        }
    }

    private func unlikePost() {
//        likesCount? -= 1
        apiService.deleteLike(username: user.username, postId: postId) { result in
            switch result {
            case .success:
                userLiked.toggle()
                isLoading = false
            case .failure(let error):
                print("Error unliking post: \(error.localizedDescription)")
                isLoading = false
            }
        }
    }
    
}

struct SelfInteractionButtonMenu_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "testUsername")
        
        return SelfInteractionButtonMenu<MockAPIService>(showCommentSection: .constant(false), apiService: MockAPIService(), postId: 1, likesCount: 1234, commentCount: 8, userLiked: true)
            .environmentObject(testUser)
            .background(Color("GradientDark3"))
    }
}
