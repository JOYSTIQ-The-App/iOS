//
//
//  ProfileTabView.swift
//  JOYSTIQ
//
//  Created by cs dev on 4/10/23.
//

import SwiftUI
import Amplify

struct ProfileTabView<APIServiceType: APIServiceProtocol, AuthServiceType: AuthServiceProtocol & ObservableObject>: View {
    // MARK: - Properties
    @EnvironmentObject var authService: AuthServiceType
    @EnvironmentObject var user: User
    @EnvironmentObject var playerManager: PlayerManager
    
    var apiService: APIServiceType
    
    @State private var showSocials = false
    @State private var showResume = false
    @Binding var hideNavBar: Bool
    @State private var avatarSnapshot: UIImage?
    @State private var enviroInt: Int = 0
    
    @State private var bio: String = ""
    @State private var resume: String = ""
    @State private var followers: Int = 0
    @State private var following: Int = 0
    
    @State private var userPosts: [Post] = []
    //@State private var showEditPostModal = false
    //@State private var currentEditingPost: Post? = nil
    
    @State var showCommentSection: Bool = false
    
    @State private var showDeleteConfirmation = false
    @State private var postToDelete: Int? // Store the post ID to delete if confirmed
    
    @State private var avatarS3Key: S3Key = S3Key(String: "", Valid: false)
    
    @State private var userSocials: [String: String]?
    @State private var isLoading: Bool = false
    @State private var isLoadingAvatar: Bool = false

    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                mainContent
                if showSocials {
                    socialsModal
                }
                if showResume {
                    resumeModal
                }
                
                if isLoading {
                    loadingOverlay
                }
            }
            .accentColor(Color(.label))
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
        .frame(maxWidth: .infinity, maxHeight: .infinity) // To ensure it covers the entire screen
    }
    
    private var mainContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
                avatarSection
                
                AccoladeBanner()
                    .padding(.vertical, 10)
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
            }
            .background(Color("GradientDark3"))
        } //end main scrollview
        .edgesIgnoringSafeArea([.top, .bottom])
        .onAppear {
            fetchUserProfile()
            hideNavBar = false
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(title: Text("Delete Post"),
                  message: Text("Are you sure you want to delete this post?"),
                  primaryButton: .destructive(Text("Delete")) {
                      if let postId = postToDelete {
                          deletePost(postId: postId)
                      }
                  },
                  secondaryButton: .cancel {
                      postToDelete = nil // Reset the postToDelete when canceled
                  }
            )
        }
        .background(Color("GradientDark3"))
    }

    private var avatarSection: some View {
        VStack(spacing: 0) {
            
            ZStack(alignment: .bottom) { //to push wardrobe and settings buttons to bottom of avatar frame
                
                ZStack(alignment: .center) {
                    avatarBackground
                    avatarImage
                }
                .shadow(color: Color.black.opacity(0.6), radius: 1, x: -1, y: 1)
                
                HStack {
                    wardrobeButton
                    Spacer()
                    settingsButton
                }
                .padding(.horizontal)
                .padding(.bottom, UIScreen.main.bounds.height * 0.03)
                .shadow(color: Color.black.opacity(0.4), radius: 1, x: 1, y: 1)
            }
            .padding(.bottom, 1)

            bioSection
        } //end Vstack for avatar environment and bio
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
                VStack {
                    Text("Create your Avatar!")
                        .frame(width: 200, height: 50)
                        .foregroundColor(.black)
                    Image(systemName: "arrow.down.left")
                        .frame(width: 10, height: 10)
                        .foregroundColor(.black)
                }
            )
        }
    }
    
    private var wardrobeButton: some View {
        NavigationLink(destination: WardrobeView(hideNavBar: $hideNavBar, avatarSnapshot: $avatarSnapshot, enviroInt: $enviroInt, avatarS3Key: $avatarS3Key, apiService: apiService).navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Wardrobe")
                }
            }) {
            ZStack {
                Image(systemName: "square")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color("LightGray"))
                
                Image(systemName: "tshirt.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("LightGray"))
            }
        }
    }

    private var settingsButton: some View {
        NavigationLink(destination: ProfileSettingsView<APIServiceType, AuthServiceType>(apiService: apiService, hideNavBar: $hideNavBar).navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.system(size: 18))
                        .foregroundColor(Color(.label))
                }
            }) {
            ZStack {
                Image(systemName: "square")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color("LightGray"))
                
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("LightGray"))
            }
        }
    }
    
    private var followersButtons: some View {
        HStack(spacing: 10) {
            NavigationLink(destination: FollowersListView(apiService: apiService, username: user.username)) {
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
            
            NavigationLink(destination: FollowingListView(apiService: apiService, username: user.username)) {
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
            
            
            Text(bio)
                .padding(.all, 13)
                .background(Color("Black0").opacity(0.3))
                .cornerRadius(15, corners: [.topRight, .bottomRight])
                .frame(minWidth: UIScreen.main.bounds.width * 0.3, maxWidth: UIScreen.main.bounds.width * 0.4, alignment: .topLeading)
                .font(.system(size: UIScreen.main.bounds.width * 0.03))
                .foregroundColor(Color("LightGray"))
             
             
         }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("GradientDark"), Color("GradientLight"), Color("GradientLight")]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
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
            Text(user.username)
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
    
    
    private func resumeButton(imageName: String) -> some View {
        Button(action: {
            showResume.toggle()
        }) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(Color("LightGray"))
        }
        .buttonStyle(NeumorphicButtonStyle())
        .padding(.trailing, 10)
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
    
    private var resumeModal: some View {
        ZStack {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showResume = false
                }
            //Resume View
        }
    }
    

    private var userPostsScrollView: some View {
        LazyVStack(spacing: 0) {
            ForEach(userPosts, id: \.id) { post in
                ProfilePostView(
                    apiService: apiService,
                    post: post,
                    avatarS3Key: avatarS3Key
                )
                .environmentObject(user)
                .environmentObject(playerManager)
                                  
                
                HStack { //for interaction buttons and delete post
                    SelfInteractionButtonMenu(
                        showCommentSection: $showCommentSection,
                        apiService: apiService,
                        postId: post.id,
                        likesCount: post.likes,
                        commentCount: post.comments,
                        userLiked: post.user_liked
                    )
                    .environmentObject(user)
                    
                    
                    
                    Button(action: {
                        deletePostConfirmation(postId: post.id)
                    }) {
                        Image(systemName: "trash.fill")
                            .foregroundColor(Color("LightGray"))
                    }
                    .padding(.trailing, 25)
                    .padding(.bottom, 10)
                }
                .padding(.top, 10)

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
        //.padding(.top, 10)
    }
  
    // MARK: - Functions
    func fetchUserProfile() {
        isLoading = true
        apiService.getUserProfile(for: user.username) { result in
            handleFetchResult(result)
        }
    }
    
    private func handleFetchResult(_ result: Result<UserProfile, Error>) {
        switch result {
        case .success(let Profile):
            if Profile.avatar_s3_key.Valid {
                isLoadingAvatar = true
                avatarS3Key = Profile.avatar_s3_key
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
    
    // This function prompts the user to confirm deletion.
    func deletePostConfirmation(postId: Int) {
        postToDelete = postId
        showDeleteConfirmation = true
    }


    // This function calls the API to delete the post and updates the local userPosts list on success.
    func deletePost(postId: Int) {
        apiService.deletePost(email: user.email, postId: postId) { result in
            switch result {
            case .success():
                userPosts.removeAll { $0.id == postId }
            case .failure(let error):
                print("Error deleting post: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Preview
struct ProfileTabView_Previews: PreviewProvider {

    let blankImage = UIImage()

    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "Apical")
        
        return ProfileTabView<MockAPIService, MockAuthService>(apiService: MockAPIService(), hideNavBar: .constant(false))
            .environmentObject(testUser)
            .environmentObject(MockAuthService())
            .environmentObject(PlayerManager())
    }
}
