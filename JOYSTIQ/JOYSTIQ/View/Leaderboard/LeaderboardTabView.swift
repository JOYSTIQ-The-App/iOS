//
//  NewsView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 4/10/23.
//

import SwiftUI
import AVKit
import Amplify

struct LeaderboardTabView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    @EnvironmentObject var playerManager: PlayerManager
    var apiService: APIServiceType
    
    @State private var showingReportAlert = false
    @State private var posts: [Post] = []
    @State var showCommentSection: Bool = false
    @State private var isLoading: Bool = false
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                mainContent
                
                if isLoading {
                    loadingOverlay
                }
            }
            .accentColor(Color.green)
        }
    }
    
    // MARK: - Subviews
    private var loadingOverlay: some View {
        ZStack {
            // This semi-transparent view will cover the entire content
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            // Your loading circle
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // To ensure it covers the entire screen
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            feedView
        }
        .background(Color("GradientDark3"))
        .alert(isPresented: $showingReportAlert, content: reportAlert)
        .onAppear {
            fetchPosts()
        }
    }
    
    private var feedView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(Array(posts.enumerated()), id: \.element.id) { index, post in
                    LeaderboardBanners(placeValue: index + 1)
                        .padding(.bottom, 5)
                    
                    PostView(
                        apiService: apiService,
                        post: post,
                        showCommentSection: $showCommentSection
                    )
                    .environmentObject(user)
                    .environmentObject(playerManager)

                    Spacer()
                }
            }
            .background(Color("GradientDark3"))
        }
        .background(Color("GradientDark3"))
    }
    
    // MARK: - Funtions
    private func fetchPosts() {
        isLoading = true
        apiService.getLeaderboardFeed(for: user.email){ result in
            handleFetchResult(result)
        }
    }
    
    private func handleFetchResult(_ result: Result<[Post], Error>) {
        switch result {
        case .success(let fetchedPosts):
            fetchURLsForPosts(fetchedPosts) { updatedPosts in
                var sortedPosts = updatedPosts
                sortedPosts.sort { $0.created_at > $1.created_at }
                posts = []
                posts = sortedPosts
                
                isLoading = false
            }
        case .failure(let error):
            print("Error fetching feed: \(error.localizedDescription)")
            isLoading = false
        }
    }
    
    private func fetchURLsForPosts(_ inputPosts: [Post], completion: @escaping ([Post]) -> Void) {
        let group = DispatchGroup()
        var updatedPosts: [Post] = []

        for var post in inputPosts {
            if post.s3_key.Valid {
                group.enter()
                Task {
                    do {
                        let url = try await Amplify.Storage.getURL(key: post.s3_key.String)
                        post.mediaURL = url
                        if post.thumbnail_s3_key.Valid {
                            let thumbnail = try await Amplify.Storage.getURL(key: post.thumbnail_s3_key.String)
                            post.thumbnailURL = thumbnail
                        }
                        updatedPosts.append(post)
                    } catch {
                        print("Error fetching URL: \(error)")
                    }
                    group.leave()
                }
            } else {
                updatedPosts.append(post)
            }
        }

        group.notify(queue: .main) {
            completion(updatedPosts)
        }
    }
    
    // MARK: - Alert
    private func reportAlert() -> Alert {
        Alert(
            title: Text("Report Post"),
            message: Text("Are you sure you would like to report this post for violating JOYSTIQ terms and conditions?"),
            primaryButton: .default(Text("Report")),
            secondaryButton: .cancel(Text("Cancel"))
        )
    }
}

// MARK: - Preview
struct LeaderboardTabView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "testUsername")
        
        LeaderboardTabView<MockAPIService>(apiService: MockAPIService())
            .environmentObject(testUser)
            .environmentObject(PlayerManager())
    }
}
