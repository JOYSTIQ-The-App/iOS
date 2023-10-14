//
//  PostView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/10/23.
//

import SwiftUI

struct PostView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    var apiService: APIServiceType
    var post: FeedPost
    @Binding var showCommentSection: Bool
    
    @State private var showingReportAlert: Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            UserBannerPostView(apiService: apiService, userId: post.user_id, game: post.game)
                .environmentObject(user)
            
            LazyVStack(alignment: .leading, spacing: 0) {
                if let s3Key = post.s3_key?.String, post.s3_key?.Valid == true {
                    PostContentView(s3_key: s3Key, bodyText: post.body, mediaType: MediaType(from: post.media))
                } else {
                    PostContentView(s3_key: nil, bodyText: post.body, mediaType: .none)
                }
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
        let testPost = FeedPost(
            id: 1,
            user_id: 2,
            s3_key: S3Key(String: "sampleImageKey", Valid: false),
            media: "none",
            game: "Valorant",
            body: "This is a sample post content",
            status: "reported",
            likes: 123,
            comments: 45,
            created_at: "2023-10-10T14:48:00.000Z",
            user_liked: true
        )
        
        return PostView<MockAPIService>(
            apiService: MockAPIService(),
            post: testPost,
            showCommentSection: .constant(false)
        )
        .environmentObject(testUser)
        .background(Color.black) // just to make it more visually clear in the preview
    }
}
