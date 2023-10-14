//
//  NewsView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 4/10/23.
//

import SwiftUI
import AVKit

struct LeaderboardTabView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    var apiService: APIServiceType
    
    @State private var showingReportAlert = false
    @State private var posts: [FeedPost] = []
    @State var showCommentSection: Bool = false
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                mainContent
            }
        }
    }
    
    // MARK: - Subviews
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

                    Spacer()
                }
            }
            .background(Color("GradientDark3"))
        }
        .background(Color("GradientDark3"))
    }
    
    // MARK: - Funtions
    private func fetchPosts() {
        Task {
            apiService.getLeaderboardFeed(for: user.email){ result in
                switch result {
                case .success(let fetchedPosts):
                    posts = fetchedPosts
                case .failure(let error):
                    print("Error fetching user feed: \(error.localizedDescription)")
                }
            }
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
    }
}
