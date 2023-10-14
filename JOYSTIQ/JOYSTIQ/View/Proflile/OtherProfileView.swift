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
    var apiService: APIServiceType
    var profileUsername: String
    @Binding var showCommentSection: Bool
    
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
    @State private var isLoading: Bool = false
    
    @State private var userPosts: [FeedPost] = []
    
    @State private var showingReportAlert = false
    
    @State private var avatarS3Key: String?
    
    @State private var userSocials: [String: String]?
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                mainContent
                if showSocials {
                    socialsModal
                }
                //if showResume {
                //  resumeModal
                //}
            }
            .accentColor(Color(.label))
        }
    }
    
    // MARK: - Subviews
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
            fetchUserPosts()
            fetchUserSocials()
            
            // Fetch the avatar using the assured username
            apiService.getUserAvatar(username: profileUsername) { result in
                switch result {
                case .success(let avatar):
                    if let key = avatar.s3_key {
                        fetchAvatarImage(s3Key: key)
                        avatarS3Key = key
                    }
                    
                    if avatar.environment == "gameroom" {
                        enviroInt = 1
                    }
                    
                case .failure(let error):
                    print("Error fetching avatar s3Key: \(error.localizedDescription)")
                }
            }
        }
        .alert(isPresented: $showingReportAlert) {
            Alert(
                title: Text("Report Post"),
                message: Text("Are you sure you would like to report this post for violating JOYSTIQ terms and conditions?"),
                primaryButton: .default(Text("Report")),
                secondaryButton: .cancel(Text("Cancel"))
            )
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
            ForEach(userPosts, id: \.id) { post in
                PostView(
                    apiService: apiService,
                    post: post,
                    showCommentSection: $showCommentSection
                )
                .environmentObject(user)

                Divider()
                    .frame(width: UIScreen.main.bounds.width, height: 1)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("GradientDark3"), Color("GradientLight"), Color("GradientDark3")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Spacer()
            }
        }
        .background(Color("GradientDark3"))
        .padding(.top, 10)
    }
  
    // MARK: - Functions
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
                    DispatchQueue.main.async {
                        avatarSnapshot = image
                    }
                }
            } catch {
                print("Error fetching avatar image: \(error)")
            }
        }
    }

    func fetchUserProfile() {
        apiService.getUserProfile(for: profileUsername) { result in
            switch result {
            case .success(let profile):
                self.bio = profile.bio
                //self.resume = profile.resume
                self.followers = profile.followers
                self.following = profile.following
            case .failure(let error):
                print("Error fetching user profile: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchUserSocials() {
        apiService.getUserSocials(for: profileUsername) { result in
            switch result {
            case .success(let socials):
                self.userSocials = socials
            case .failure(let error):
                print("Error fetching user's socials: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchUserPosts() {
        apiService.getUserPosts(for: profileUsername) { result in
            switch result {
            case .success(let posts):
                self.userPosts = posts
            case .failure(let error):
                print("Error fetching user's posts: \(error.localizedDescription)")
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
        followers += 1
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
        followers -= 1
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
        
        return OtherProfileView<MockAPIService>(apiService: MockAPIService(), profileUsername: "Apical", showCommentSection: .constant(false))
            .environmentObject(testUser)
    }
}
