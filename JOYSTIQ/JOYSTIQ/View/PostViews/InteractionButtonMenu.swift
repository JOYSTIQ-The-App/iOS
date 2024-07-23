//
//  InteractionButtonMenu.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 7/26/23.

import SwiftUI

struct InteractionButtonMenu<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    @Binding var showingReportAlert: Bool
    var apiService: APIServiceType
    var postId: Int
    @State var likesCount: Int? = nil
    @State var commentCount: Int
    @State var userLiked: Bool
    @State private var showComment: Bool = false

    // MARK: - Body
    var body: some View {
        HStack { //for like, comment, report buttons
            Button(action: {
                print("Like button pressed on post id", postId)
                likeButtonAction()
            }) {
                LikeButton(isLiked: $userLiked, likesCount: $likesCount)
            }
            .padding(.trailing, 5)
            
            Button(action: {
                print("Comment button pressed on post id", postId)
                showComment = true
            }) {
                CommentButton(commentCount: commentCount)
            }
            .sheet(isPresented: $showComment) {
                CommentSectionView<APIService>(apiService: apiService, postId: postId)
                    .presentationDetents([.fraction(0.9)])
            }
            
            Spacer()
            
            Button(action: {
                showingReportAlert = true
            }) {
                Image(systemName: "flag")
                    .imageScale(.small)
                    .foregroundColor(.white).opacity(0.7)
            }
        }
        .padding(.horizontal, ScreenUtil.width * 0.05)
        .padding(.vertical, ScreenUtil.height * 0.01)
    }

    // MARK: - Functions
    private func likeButtonAction() {
        if userLiked {
            userLiked = false
            unlikePost()
        } else {
            userLiked = true
            likePost()
        }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
    }

    private func likePost() {
        apiService.createLike(username: user.username, postId: postId) { result in
            switch result {
            case .success:
//                userLiked = true
                print("success")
            case .failure(let error):
                print("Error liking post: \(error.localizedDescription)")
            }
        }
    }

    private func unlikePost() {
        apiService.deleteLike(username: user.username, postId: postId) { result in
            switch result {
            case .success:
//                userLiked = false
                print("success")
            case .failure(let error):
                print("Error unliking post: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Preview
struct InteractionButtonMenu_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "testUsername")
        
        return InteractionButtonMenu<MockAPIService>(
            showingReportAlert: .constant(false),
            apiService: MockAPIService(),
            postId: 1,
            likesCount: 1234,
            commentCount: 8,
            userLiked: true
        )
        .environmentObject(testUser)
        .background(Color("GradientDark3"))
    }
}
