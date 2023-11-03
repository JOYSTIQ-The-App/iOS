//
//  ProfilePostView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/17/23.
//

import SwiftUI
import AVKit

struct ProfilePostView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    @EnvironmentObject var playerManager: PlayerManager
    var apiService: APIServiceType
    var post: Post
    var avatarS3Key: S3Key
    
    @State private var player: AVPlayer? = nil
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            UserBannerPostView(apiService: apiService, game: post.game, username: user.username, avatarS3Key: avatarS3Key, createdAt: post.created_at, isAvatarFullScreen: .constant(false))
                .environmentObject(user)
            
            if post.s3_key.Valid {
                if post.media == "video" {
                    PostContentView(s3_key: post.s3_key, thumbnail: post.thumbnail_s3_key, bodyText: post.body, mediaType: MediaType(from: post.media), vURL: post.mediaURL, tURL: post.thumbnailURL)
                } else if post.media == "photo" {
                    PostContentView(s3_key: post.s3_key, bodyText: post.body, mediaType: MediaType(from: post.media), imageURL: post.mediaURL)
                } else {
                    PostContentView(s3_key: post.s3_key, bodyText: post.body, mediaType: MediaType(from: post.media))
                }
            } else {
                PostContentView(s3_key: post.s3_key, bodyText: post.body, mediaType: MediaType(from: post.media))
            }
            
        }
    }
}

// MARK: - Preview
struct ProfilePostView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "testUsername")
        let testPost = Post(
            id: 1,
            user_id: 2,
            s3_key: S3Key(String: "", Valid: false),
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
            avatar_s3_key: S3Key(String: "", Valid: false)
        )
        
        return ProfilePostView<MockAPIService>(
            apiService: MockAPIService(),
            post: testPost,
            avatarS3Key: S3Key(String: "", Valid: false)
        )
        .environmentObject(testUser)
        .environmentObject(PlayerManager())
        .background(Color.black) // just to make it more visually clear in the preview
    }
}

