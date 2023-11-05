//
//  HomeTabView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 4/10/23.
//

import SwiftUI
import SwiftUIX
import Amplify

struct ScrollOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct HomeTabView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    @EnvironmentObject var playerManager: PlayerManager
    var apiService: APIServiceType
    @Binding var opacity: Double
    
    @State private var showDropDown = false
    @State private var selectedFeed: FeedType = .following
    @State private var posts: [Post] = []
    @State var showCommentSection: Bool = false
    
    @State private var lastSeenCreatedAt: String? = nil
    @State private var showLoadMoreButton = false
    @State private var isLoading: Bool = false
    
    @State private var isRefreshing = false
    
    @State private var previousOffset: CGFloat = 0.0
    @State private var pullOffset: CGFloat = 0.0
    @State private var hasStartedScrolling: Bool = false
    @State private var firstScrollEvent: Bool = true
    @State private var showHeader: Bool = true
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                mainContent
                
                if isLoading {
                    loadingOverlay
                }
                
                dropDownView
            }
            .accentColor(Color.green)
        }
    }
    
    // MARK: - Subviews
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var mainContent: some View {
        ZStack(alignment: .top) {
            feedView
                .padding(.top, showHeader ? 100 : 0)
            
            if showHeader {
                header
            }
        }
        .background(Color("GradientDark3"))
        .onAppear {
            fetchPosts()
        }
        .accentColor(Color.green)
    }
    
    private var header: some View {
        HomeHeaderView(
            apiService: apiService,
            showDropDown: $showDropDown,
            selectedFeed: $selectedFeed
        )
        .onChange(of: selectedFeed) { _ in
            posts = []
            isLoading = true
            showLoadMoreButton = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.fetchPosts()
            }
        }
    }
    
    private var dropDownView: some View {
        ZStack {
            if showDropDown {
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { showDropDown = false }
                
                DropDown2(feedbackService: FeedbackService(), showDropDown: $showDropDown)
            }
        }
    }
    
    private var feedTypePicker: some View {
        Picker("", selection: $selectedFeed) {
            Text("Following").tag(FeedType.following)
            Text("Global").tag(FeedType.global)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding([.vertical, .horizontal], 10)
        
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
        ScrollViewReader { scrollView in
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
                .background(
                    GeometryReader { geometry in
                        Color.clear.preference(key: ScrollOffsetKey.self, value: geometry.frame(in: .global).minY)
                    }
                )
                .background(Color("GradientDark3"))
            }
            .onPreferenceChange(ScrollOffsetKey.self) { offsetY in
                            
                let difference = previousOffset - offsetY
                previousOffset = offsetY

                // Check if user is near the top of the scroll view
                if offsetY > -200.0 {
                    withAnimation {
                        showHeader = true
                    }
                } else {
                    withAnimation {
                        if difference > 10 {
                            showHeader = false
                        } else if difference < -15 {
                            showHeader = true
                        }
                    }
                }
                
                if offsetY > -200.0 {
                    opacity = 1.0
                } else {
                    if difference > 10 {
                        opacity = 0.5
                    } else if difference < -15 {
                        opacity = 1.0
                    }
                }
                
                
            }
            .background(Color("GradientDark3"))
            .refreshable {
                self.refreshAction()
            }
            .onAppear {
                UIRefreshControl.appearance().tintColor = .white
            }
        }
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
    
    private func refreshAction() {
        // Handle your refresh logic here...
        fetchPosts()

        // After data is fetched, stop refreshing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isRefreshing = false
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
    
}

// MARK: - Preview
struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "testUsername")
        
        return HomeTabView<MockAPIService>(apiService: MockAPIService(), opacity: .constant(1.0))
            .environmentObject(testUser)
            .environmentObject(PlayerManager())
    }
}
