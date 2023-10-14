//
//  HomeTabView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 4/10/23.
//

import SwiftUI

struct HomeTabView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    var apiService: APIServiceType
    
    @State private var showDropDown = false
    @State private var selectedFeed: FeedType = .following
    @State private var posts: [FeedPost] = []
    @State var showCommentSection: Bool = false
    
    @State private var lastSeenCreatedAt: String? = nil
    @State private var showLoadMoreButton = false
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                mainContent
            }
            .accentColor(Color.green)
        }
    }
    
    // MARK: - Subviews
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

    private func handleFetchResult(_ result: Result<[FeedPost], Error>) {
        switch result {
        case .success(let fetchedPosts):
            posts = []
            posts = fetchedPosts
            
            if fetchedPosts.count < 10 {
                showLoadMoreButton = false
            } else {
                showLoadMoreButton = true
            }
        case .failure(let error):
            print("Error fetching feed: \(error.localizedDescription)")
        }
    }
    
    private func handleFetchMoreResult(_ result: Result<[FeedPost], Error>) {
        switch result {
        case .success(let fetchedPosts):
            posts.append(contentsOf: fetchedPosts.filter { newPost in
                !posts.contains(where: { existingPost in
                    existingPost.id == newPost.id
                })
            })
            
            if fetchedPosts.count < 10 {
                showLoadMoreButton = false
            }
        case .failure(let error):
            print("Error fetching more feed: \(error.localizedDescription)")
        }
    }
    
}

// MARK: - Preview
struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "testUsername")
        
        return HomeTabView<MockAPIService>(apiService: MockAPIService())
            .environmentObject(testUser)
    }
}
