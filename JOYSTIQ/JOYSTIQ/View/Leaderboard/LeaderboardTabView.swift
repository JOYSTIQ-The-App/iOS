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
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            feedView
        }
        .background(Color("GradientDark3"))
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
            posts = fetchedPosts
            isLoading = false
        case .failure(let error):
            print("Error fetching feed: \(error.localizedDescription)")
            isLoading = false
        }
    }
    
    // MARK: - Alert
//    private func reportAlert() -> Alert {
//        Alert(
//            title: Text("Report Post"),
//            message: Text("Are you sure you would like to report this post for violating JOYSTIQ terms and conditions?"),
//            primaryButton: .default(Text("Report")),
//            secondaryButton: .cancel(Text("Cancel"))
//        )
//    }
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
