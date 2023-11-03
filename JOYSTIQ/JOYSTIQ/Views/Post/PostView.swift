//
//  PostView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/10/23.
//

import SwiftUI
import AVKit

struct PostView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    @EnvironmentObject var playerManager: PlayerManager
    var apiService: APIServiceType
    var post: Post
    @Binding var showCommentSection: Bool
    
    @State private var showingReportAlert: Bool = false
    
    @State private var isAvatarFullScreen = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            UserBannerPostView(apiService: apiService, game: post.game, username: post.username, avatarS3Key: post.avatar_s3_key, createdAt: post.created_at, isAvatarFullScreen: $isAvatarFullScreen)
                .environmentObject(user)
                .padding(.top, 5)
                .zIndex(isAvatarFullScreen ? 2 : 0)
            
            if post.s3_key.Valid {
                if post.media == "video" {
                    PostContentView(s3_key: post.s3_key, thumbnail: post.thumbnail_s3_key, bodyText: post.body, mediaType: MediaType(from: post.media), vURL: post.mediaURL, tURL: post.thumbnailURL)
                        .zIndex(1)
                } else if post.media == "photo" {
                    PostContentView(s3_key: post.s3_key, bodyText: post.body, mediaType: MediaType(from: post.media), imageURL: post.mediaURL)
                        .zIndex(1)
                } else {
                    PostContentView(s3_key: post.s3_key, bodyText: post.body, mediaType: MediaType(from: post.media))
                        .zIndex(1)
                }
            } else {
                PostContentView(s3_key: post.s3_key, bodyText: post.body, mediaType: MediaType(from: post.media))
                    .zIndex(1)
            }
            
            InteractionButtonMenu(
                showCommentSection: $showCommentSection,
                showingReportAlert: $showingReportAlert,
                apiService: apiService,
                postId: post.id,
                likesCount: post.likes,
                commentCount: post.comments,
                userLiked: post.user_liked
            )
            .environmentObject(user)
            .alert(isPresented: $showingReportAlert, content: reportAlert)
            
            Divider()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("GradientDark3"), Color("GradientLight"), Color("GradientDark3")]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
    }
    
    // MARK: - Alert
    private func reportAlert() -> Alert {
        Alert(
            title: Text("Report Post"),
            message: Text("Are you sure you would like to report this post for violating JOYSTIQ terms and conditions?"),
            primaryButton: .default(Text("Report")) {
                apiService.reportPost(username: user.username, postId: post.id) { result in
                    switch result {
                    case .success():
                        print(post.id)
                        print("Post reported successfully.")
                    case .failure(let error):
                        print("Error reporting post: \(error.localizedDescription)")
                    }
                }
            },
            secondaryButton: .cancel(Text("Cancel"))
        )
    }
}

// MARK: - Preview
struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "testUsername")
        let testPost = Post(
            id: 1,
            user_id: 2,
            s3_key: S3Key(String: "sampleImageKey", Valid: false),
            thumbnail_s3_key: S3Key(String: "", Valid: false),
            media: "none",
            game: "Valorant",
            body: "This is a sample post content",
            status: "reported",
            likes: 123,
            comments: 45,
            created_at: "2023-10-10T14:48:00.000Z",
            user_liked: true,
            username: "SampleUser",
            avatar_s3_key: S3Key(String: "sampleImageKey", Valid: false)
        )
        
        return PostView<MockAPIService>(
            apiService: MockAPIService(),
            post: testPost,
            showCommentSection: .constant(false)
        )
        .environmentObject(testUser)
        .background(Color("GradientDark3")) // just to make it more visually clear in the preview
        .environmentObject(PlayerManager())
    }
}
