//
//  HomeTabView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 4/10/23.
//

import SwiftUI
import Amplify

struct HomeTabView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    @EnvironmentObject var playerManager: PlayerManager
    var apiService: APIServiceType
    
    @State private var showDropDown = false
    @State private var selectedFeed: FeedType = .following
    @State private var posts: [Post] = []
    @State var showCommentSection: Bool = false
    
    @State private var lastSeenCreatedAt: String? = nil
    @State private var showLoadMoreButton = false
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
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            // Your loading circle
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // To ensure it covers the entire screen
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            feedTypePicker
            feedView
        }
        .background(Color("GradientDark3"))
        .onAppear {
            fetchPosts()
        }
    }
    
    private var feedTypePicker: some View {
        Picker("", selection: $selectedFeed) {
            Text("Following").tag(FeedType.following)
            Text("Global").tag(FeedType.global)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .onChange(of: selectedFeed) { _ in
            posts = []
            isLoading = true
            showLoadMoreButton = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                fetchPosts()
            }
        }

    }
    
    private var loadMoreButton: some View {
        Group {
            if showLoadMoreButton {
                Button("Load More") {
                    fetchMorePosts()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
    }
    
    private var feedView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(posts) { post in
                    PostView(
                        apiService: apiService,
                        post: post,
                        showCommentSection: $showCommentSection
                    )
                    .environmentObject(user)
                    .environmentObject(playerManager)
                }
                
                loadMoreButton
            }
            .background(Color("GradientDark3"))
        }
        .background(Color("GradientDark3"))
    }
    
    // MARK: - Funtions
    private func fetchPosts() {
        lastSeenCreatedAt = nil
        showLoadMoreButton = false
        isLoading = true
        
        switch selectedFeed {
        case .following:
            apiService.getUserFeed(for: user.email, lastSeenCreatedAt: lastSeenCreatedAt) { result in
                handleFetchResult(result)
            }
        case .global:
            apiService.getGlobalFeed(for: user.email, lastSeenCreatedAt: lastSeenCreatedAt) { result in
                handleFetchResult(result)
            }
        }
    }
    
    private func fetchMorePosts() {
        showLoadMoreButton = false
        isLoading = true
        
        if let lastPost = posts.last {
            lastSeenCreatedAt = lastPost.created_at
        }
        
        switch selectedFeed {
        case .following:
            apiService.getUserFeed(for: user.email, lastSeenCreatedAt: lastSeenCreatedAt) { result in
                handleFetchMoreResult(result)
            }
        case .global:
            apiService.getGlobalFeed(for: user.email, lastSeenCreatedAt: lastSeenCreatedAt) { result in
                handleFetchMoreResult(result)
            }
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
                
                if sortedPosts.count < 10 {
                    showLoadMoreButton = false
                } else {
                    showLoadMoreButton = true
                }
                
                isLoading = false
            }
        case .failure(let error):
            print("Error fetching feed: \(error.localizedDescription)")
            isLoading = false
        }
    }

    private func handleFetchMoreResult(_ result: Result<[Post], Error>) {
        switch result {
        case .success(let fetchedPosts):
            fetchURLsForPosts(fetchedPosts) { updatedPosts in
                var sortedPosts = updatedPosts
                sortedPosts.sort { $0.created_at > $1.created_at }
                posts.append(contentsOf: sortedPosts.filter { newPost in
                    !posts.contains(where: { existingPost in
                        existingPost.id == newPost.id
                    })
                })
                
                if sortedPosts.count < 10 {
                    showLoadMoreButton = false
                } else {
                    showLoadMoreButton = true
                }
                
                isLoading = false
            }
        case .failure(let error):
            print("Error fetching more feed: \(error.localizedDescription)")
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
    
}

// MARK: - Preview
struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "testUsername")
        
        return HomeTabView<MockAPIService>(apiService: MockAPIService())
            .environmentObject(testUser)
            .environmentObject(PlayerManager())
    }
}
