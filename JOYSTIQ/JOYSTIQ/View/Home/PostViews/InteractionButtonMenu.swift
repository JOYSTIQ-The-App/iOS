//
//  InteractionButtonMenu.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 7/26/23.
//

import SwiftUI

struct InteractionButtonMenu<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    @Binding var showCommentSection: Bool
    @Binding var showingReportAlert: Bool
    var APIService: APIServiceType
    var postId: Int
    @State var likesCount: Int? = nil
    @State var commentCount: Int
    @State var userLiked: Bool
    @State private var isLoading: Bool = false

    // MARK: - Body
    var body: some View {
        HStack {
            loadingOrButtonContent
            CommentButton<APIService>(APIService: APIService, postId: postId, commentCount: commentCount)
                .onTapGesture {
                    showCommentSection.toggle()
                }
            Spacer()
            reportButton
        }
        .padding(.horizontal, 25)
        .padding(.bottom, 8)
    }

    // MARK: - Subviews
    private var loadingOrButtonContent: some View {
        if isLoading {
            return AnyView(
                ProgressView()
                    .scaleEffect(1.5)
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

    private var reportButton: some View {
        Button(action: {
            showingReportAlert = true
        }) {
            Image(systemName: "flag")
                .imageScale(.small)
                .padding(.trailing, 10)
                .foregroundColor(.white).opacity(0.7)
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
        likesCount? += 1
        APIService.createLike(username: user.username, postId: postId) { result in
            isLoading = false
            switch result {
            case .success:
                userLiked.toggle()
            case .failure(let error):
                print("Error liking post: \(error.localizedDescription)")
            }
        }
    }

    private func unlikePost() {
        likesCount? -= 1
        APIService.deleteLike(username: user.username, postId: postId) { result in
            isLoading = false
            switch result {
            case .success:
                userLiked.toggle()
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
            showCommentSection: .constant(false),
            showingReportAlert: .constant(false),
            APIService: MockAPIService(),
            postId: 1,
            likesCount: 1234,
            commentCount: 8,
            userLiked: true
        )
        .environmentObject(testUser)
        .background(Color("GradientDark3"))
    }
}
