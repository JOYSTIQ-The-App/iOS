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
    var APIService: APIServiceType
    
    @State private var showDropDown = false
    @State private var showingReportAlert = false
    @State private var posts: [Post] = []
    @Binding var showCommentSection: Bool
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                mainContent
                dropDownView
            }
        }
    }
    
    // MARK: - Subviews
    private var mainContent: some View {
        VStack(spacing: 0) {
            HeaderView(showDropDown: $showDropDown)
            refreshButton
            feedView
        }
        .background(Color("GradientDark3"))
        .alert(isPresented: $showingReportAlert, content: reportAlert)
        .onAppear {
            Task {
                APIService.getLeaderboardFeed(){ result in
                    switch result {
                    case .success(let fetchedPosts):
                        posts = fetchedPosts
                    case .failure(let error):
                        print("Error fetching user feed: \(error.localizedDescription)")
                    }
                }
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
                ForEach(Array(posts.enumerated()), id: \.element.id) { index, post in
                    LeaderboardBanners(placeValue: index + 1)
                        .padding(.bottom, 5)
                    
                    UserBannerPostView(APIService: APIService, intVal: 1, userId: post.user_id)
                    
                    LazyVStack(alignment: .leading, spacing: 0) {
                        if let s3Key = post.s3_key?.String, post.s3_key?.Valid == true {
                            PostContentView(s3_key: s3Key, bodyText: post.body)
                        } else {
                            PostContentView(s3_key: nil, bodyText: post.body)
                        }
                    }
                    
                    InteractionButtonMenu(
                        showCommentSection: $showCommentSection,
                        showingReportAlert: $showingReportAlert,
                        APIService: APIService,
                        postId: post.id,
                        commentCount: post.comments,
                        userLiked: post.user_liked ?? false
                    )
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
    private func refreshPosts() {
        Task {
            APIService.getLeaderboardFeed(){ result in
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
        LeaderboardTabView(APIService: MockAPIService(), showCommentSection: .constant(false))
    }
}
