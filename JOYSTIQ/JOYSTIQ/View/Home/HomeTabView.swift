//
//  HomeTabView.swift
//  JOYSTIQ
//
//  Created by cs dev on 4/10/23.
//

import SwiftUI

struct HomeTabView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    var APIService: APIServiceType
    
    @State private var showDropDown = false
    @State private var showingReportAlert = false
    @State private var selectedFeed: FeedType = .following
    @State private var posts: [FeedPost] = []
    @Binding var showCommentSection: Bool
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                mainContent
                dropDownView
            }
            .accentColor(Color.green)
        }
    }
    
    // MARK: - Subviews
    private var mainContent: some View {
        VStack(spacing: 0) {
            HeaderView(showDropDown: $showDropDown)
            refreshButton
            feedTypePicker
            feedView
        }
        .background(Color("GradientDark3"))
        .alert(isPresented: $showingReportAlert, content: reportAlert)
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
            posts = [] // Clear the current posts
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Introduce a 1-second delay
                fetchPosts()
            }
        }

    }

    
    private var refreshButton: some View {
        Button(action: {
            refreshPosts()
        }) {
            Text("Refresh")
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.green)
                .cornerRadius(20)
        }
        .padding(.top, 10)
    }

    
    private var feedView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(posts) { post in
                    UserBannerPostView(APIService: APIService, intVal: 1, userId: post.user_id)
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
                        APIService: APIService,
                        postId: post.id,
                        likesCount: post.likes,
                        commentCount: post.comments,
                        userLiked: post.user_liked
                    )
                    .environmentObject(user)
                    .overlay(Rectangle().frame(height: 1, alignment: .bottom).foregroundColor(Color("LightGray").opacity(0.4)), alignment: .bottom)

                    Spacer()
                }
            }
            .background(Color("GradientDark3"))
        }
        .background(Color("GradientDark3"))
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
    
    
    // MARK: - Funtions
    private func fetchPosts() {
        switch selectedFeed {
        case .following:
            APIService.getUserFeed(for: user.email) { result in
                handleFetchResult(result)
            }
        case .global:
            APIService.getGlobalFeed(for: user.email) { result in
                handleFetchResult(result)
            }
        }
    }

    private func handleFetchResult(_ result: Result<[FeedPost], Error>) {
        switch result {
        case .success(let fetchedPosts):
            posts = []
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Introduce a 1-second delay
                posts = fetchedPosts
            }
        case .failure(let error):
            print("Error fetching feed: \(error.localizedDescription)")
        }
    }

    private func refreshPosts() {
        fetchPosts()
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
struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "testUsername")
        
        return HomeTabView<MockAPIService>(APIService: MockAPIService(), showCommentSection: .constant(false))
            .environmentObject(testUser)
    }
}
