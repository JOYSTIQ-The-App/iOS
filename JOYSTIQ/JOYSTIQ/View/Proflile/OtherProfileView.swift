//
//
//  ProfileTabView.swift
//  JOYSTIQ
//
//  Created by cs dev on 4/10/23.
//

import SwiftUI
import Amplify

struct OtherProfileView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var user: User
    @EnvironmentObject var playerManager: PlayerManager
    
    var apiService: APIServiceType
    var profileUsername: String
    @State var showCommentSection: Bool = false
    
    @State private var showSocials = false
    //@State private var showResume = false
    @State private var avatarSnapshot: UIImage?
    @State private var enviroInt: Int = 0
    
    @State private var bio: String = ""
    //@State private var resume: String = ""
    @State private var followers: Int = 0
    @State private var following: Int = 0
    @State private var isFollowingUser = false
    @State private var showFollowButton = true
    
    @State private var userPosts: [Post] = []
    
    @State private var showingReportAlert = false
    
//    @State private var avatarS3Key: String?
    
    @State private var userSocials: [String: String]?
    @State private var isLoading: Bool = false
    @State private var isLoadingAvatar: Bool = false
    
    // MARK: - Body
    var body: some View {
        //NavigationView {
            ZStack {
                mainContent
                if showSocials {
                    socialsModal
                }
                
                if isLoading {
                    loadingOverlay
                }
            }
            .accentColor(Color(.label))
        //}
    }
    
    // MARK: - Subviews
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // To ensure it covers the entire screen
    }
    
    private var mainContent: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            
            VStack(spacing: 0) {
                avatarSection
                
                AccoladeBanner()
                    .padding(.bottom, 10)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("GradientLight"), Color("GradientDark")]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                Divider()
                    .frame(width: UIScreen.main.bounds.width, height: 1)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("GradientDark3"), Color("GradientLight"), Color("GradientDark3")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("GradientDark"), Color("GradientDark3")]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 5)
                
                userPostsScrollView
            } //end VSTack for avatar, accolade, posts
            .background(Color("GradientDark3"))
        } //end main scrollview
        .edgesIgnoringSafeArea([.top, .bottom])
        .onAppear {
            if user.username == profileUsername {
                showFollowButton = false
            } else {
                fetchIsFollowing()
            }
            
            fetchUserProfile()
        }
        .background(Color("GradientDark3"))
        
        
    }

    private var avatarSection: some View {
        VStack(spacing: 0) {
            
            ZStack(alignment: .center) {
                avatarBackground
                avatarImage
            }
            .shadow(color: Color.black.opacity(0.6), radius: 1, x: -1, y: 1)
                

            bioSection
        }
    }

    private var avatarBackground: some View {
        Image(enviroInt == 1 ? "bedroomEnv" : "defaultEnv")
            .resizable()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.38)
            .edgesIgnoringSafeArea(.top)
            .aspectRatio(contentMode: .fill)
            .shadow(color: Color.black, radius: 6, x: 2, y: 4)
    }

    private var avatarImage: some View {
        if let image = avatarSnapshot {
            return AnyView(
                Image(uiImage: image)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.height * 0.28)
                    .scaleEffect(1.5)
                    .padding(.top, UIScreen.main.bounds.height * 0.05)
            )
        } else if isLoadingAvatar {
            return AnyView(
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            )
        } else {
            return AnyView(
                Text("No Avatar Yet!")
                    .frame(width: 200, height: 50)
                    .foregroundColor(.black)
            )
        }
    }
   
    private var followersButtons: some View {
        HStack(spacing: 10) {
            NavigationLink(destination: FollowersListView(apiService: apiService, username: profileUsername)) {
                VStack {
                    Text("\(followers)")
                        .font(.headline)
                        .foregroundColor(Color.white)
                    Text("Followers")
                        .font(.system(size: 8))
                        .foregroundColor(Color.white)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 15)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
            
            NavigationLink(destination: FollowingListView(apiService: apiService, username: profileUsername)) {
                VStack {
                    Text("\(following)")
                        .font(.headline)
                        .foregroundColor(Color.white)
                    Text("Following")
                        .font(.system(size: 8))
                        .foregroundColor(Color.white)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 15)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
        }
    }
    

    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            socialButtons
            HStack {
                Text(bio)
                    .padding(.all, 13)
                    .background(Color("Black0").opacity(0.3))
                    .cornerRadius(15, corners: [.topRight, .bottomRight])
                    .frame(minWidth: UIScreen.main.bounds.width * 0.3, maxWidth: UIScreen.main.bounds.width * 0.4, alignment: .topLeading)
                    .font(.system(size: UIScreen.main.bounds.width * 0.03))
                    .foregroundColor(Color("LightGray"))
                
                Spacer()
                if showFollowButton {
                    loadingOrFollowButton
                }
            }
            .padding(.bottom, UIScreen.main.bounds.height * 0.022)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("GradientDark"), Color("GradientLight"), Color("GradientLight")]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    private var loadingOrFollowButton: some View {
        if isLoading {
            return AnyView(
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .green))
                    .scaleEffect(1.5)
                    .padding(.trailing, 10)
                    .offset(y: UIScreen.main.bounds.height * 0.013)
            )
        } else {
            return AnyView(
                Button(action: {
                    followButtonAction()
                }, label: {
                    
                    Text(isFollowingUser ? "Unfollow" : "Follow")
                        .foregroundColor(.white)
                        .font(.system(size: UIScreen.main.bounds.width * 0.035))
                        .frame(width: UIScreen.main.bounds.width * 0.15, height: 20)
                        
                })
                .buttonStyle(NeumorphicRectangleButtonStyle())
                .padding(.trailing, 10)
                .offset(y: UIScreen.main.bounds.height * 0.013)
            )
        }
    }

    private var socialButtons: some View {
        HStack {
            namePlate
            Spacer()
            followersButtons
            socialButton(imageName: "network")
            //resumeButton(imageName: "list.bullet.clipboard.fill")
        }
        .frame(width: UIScreen.main.bounds.width)
        .padding(.top, 8)
    }

    private var namePlate: some View {
        ZStack {
            Image("NamePlate5")
                .resizable()
                .scaledToFill()
            Text(profileUsername)
                .font(.system(size: 16))
                .foregroundColor(Color("LightGray"))
                .padding(.trailing, UIScreen.main.bounds.width * 0.04)
        }
        .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.05)
        .shadow(color: Color.black, radius: 6, x: 2, y: 4)
        .shadow(color: Color.white.opacity(0.5), radius: 2, x: 0, y: -1)
    }

    private func socialButton(imageName: String) -> some View {
        Button(action: {
            showSocials.toggle()
        }) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(Color("LightGray"))
        }
        .buttonStyle(NeumorphicButtonStyle())
        .padding(.horizontal, 5)
    }
    

    private var socialsModal: some View {
        ZStack {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showSocials = false
                }
            SocialsView(userSocials: userSocials, showSocials: $showSocials)
        }
    }
    

    private var userPostsScrollView: some View {
        LazyVStack(spacing: 0) {
            ForEach(userPosts) { post in
                PostView(
                    apiService: apiService,
                    post: post,
                    showCommentSection: $showCommentSection
                )
                .environmentObject(user)
                .environmentObject(playerManager)
                
            }
        }
        .background(Color("GradientDark3"))
        .padding(.top, 10)
    }
  
    // MARK: - Functions
    func fetchUserProfile() {
        isLoading = true
        apiService.getGamerProfile(for: user.email, username: profileUsername) { result in
            handleFetchResult(result)
        }
    }
    
    private func handleFetchResult(_ result: Result<UserProfile, Error>) {
        switch result {
        case .success(let Profile):
            if Profile.avatar_s3_key.Valid {
                isLoadingAvatar = true
//                avatarS3Key = Profile.avatar_s3_key
                fetchAvatarImage(s3Key: Profile.avatar_s3_key.String)
            }
            bio = Profile.bio
            
            if Profile.environment == "gameroom" {
                enviroInt = 1
            }
            
            followers = Profile.followers
            following = Profile.following
            fetchURLsForPosts(Profile.posts) { updatedPosts in
                var sortedPosts = updatedPosts
                sortedPosts.sort { $0.created_at > $1.created_at }
                userPosts = sortedPosts
            }
            
            userSocials = Profile.socials
            
        case .failure(let error):
            print("Error fetching feed: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    private func fetchURLsForPosts(_ inputPosts: [Post], completion: @escaping ([Post]) -> Void) {
        var updatedPosts: [Post] = []

        Task {
            await withTaskGroup(of: (original: Post, url: URL?).self) { group in
                for post in inputPosts {
                    if post.s3_key.Valid {
                        group.addTask {
                            do {
                                let url = try await Amplify.Storage.getURL(key: post.s3_key.String)
                                return (original: post, url: url)
                            } catch {
                                print("Error fetching URL: \(error)")
                                return (original: post, url: nil)
                            }
                        }
                    } else {
                        updatedPosts.append(post)
                    }
                }

                for await result in group {
                    var post = result.original
                    post.mediaURL = result.url
                    updatedPosts.append(post)
                }
            }

            DispatchQueue.main.async {
                completion(updatedPosts)
            }
        }
    }
    
    func fetchAvatarImage(s3Key: String) {
        Task {
            do {
                let url = try await Amplify.Storage.getURL(key: s3Key)
                let data = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Data, Error>) in
                    URLSession.shared.dataTask(with: url) { (data, _, error) in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else if let data = data {
                            continuation.resume(returning: data)
                        } else {
                            let unknownError = NSError(domain: "Unknown Error", code: 0, userInfo: nil)
                            continuation.resume(throwing: unknownError)
                        }
                    }.resume()
                }
                if let image = UIImage(data: data) {
                    avatarSnapshot = image
                    isLoadingAvatar = false
                }
            } catch {
                print("Error fetching avatar image: \(error)")
            }
        }
    }
    
    func fetchIsFollowing() {
        apiService.isFollowing(username: user.username, followingUsername: profileUsername) { result in
            switch result {
            case .success(let isFollowing):
                self.isFollowingUser = isFollowing
            case .failure(let error):
                print("Error fetching isFollowing: \(error.localizedDescription)")
            }
        }
    }
    
    private func followButtonAction() {
        isLoading = true
        if isFollowingUser {
            unfollowUser()
        } else {
            followUser()
        }
    }
    
    private func followUser() {
//        followers += 1
        apiService.createFollow(username: user.username, followingUsername: profileUsername) { result in
            isLoading = false
            switch result {
            case .success:
                isFollowingUser.toggle()
            case .failure(let error):
                print("Error liking post: \(error.localizedDescription)")
            }
        }
    }

    private func unfollowUser() {
//        followers -= 1
        apiService.deleteFollow(username: user.username, followingUsername: profileUsername) { result in
            isLoading = false
            switch result {
            case .success:
                isFollowingUser.toggle()
            case .failure(let error):
                print("Error unliking post: \(error.localizedDescription)")
            }
        }
    }

}

// MARK: - Preview
struct OtherProfileView_Previews: PreviewProvider {

    let blankImage = UIImage()

    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "Apical")
        
        return OtherProfileView<MockAPIService>(apiService: MockAPIService(), profileUsername: "Apical")
            .environmentObject(testUser)
            .environmentObject(PlayerManager())
    }
}
