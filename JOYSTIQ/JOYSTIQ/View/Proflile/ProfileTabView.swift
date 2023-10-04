//
//
//  ProfileTabView.swift
//  JOYSTIQ
//
//  Created by cs dev on 4/10/23.
//

import SwiftUI
import Amplify

struct ProfileTabView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var user: User
    var APIService: APIServiceType
    
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
    @State private var showEditPostModal = false
    @State private var currentEditingPost: Post? = nil
    
    @Binding var showCommentSection: Bool
    @State private var showingReportAlert = false
    
    @State private var showDeleteConfirmation = false
    @State private var postToDelete: Int? // Store the post ID to delete if confirmed
    
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
                if showResume {
                    resumeModal
                }
            }
            .accentColor(Color(.label))
        }
    }

    // MARK: - Subviews
    private var mainContent: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                avatarSection
                AccoladeBanner()
                userPostsScrollView
                Spacer().frame(height: 300)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color("GradientDark3"), Color("GradientLight")]),
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
        }
        .edgesIgnoringSafeArea([.top, .bottom])
        .onAppear {
            fetchUserProfile()
            fetchUserPosts()
            fetchUserSocials()
            hideNavBar = false
            
            // Fetch the avatar using the assured username
            APIService.getUserAvatar(username: user.username) { result in
                switch result {
                case .success(let s3Key):
                    if let key = s3Key {
                        fetchAvatarImage(s3Key: key)
                        avatarS3Key = key
                    }
                case .failure(let error):
                    print("Error fetching avatar s3Key: \(error.localizedDescription)")
                }
            }
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
    }

    private var avatarSection: some View {
        VStack(spacing: 10) {
            ZStack {
                avatarBackground
                avatarImage
            }
            
            HStack {
                wardrobeButton
                Spacer()
                followersButtons
                Spacer()
                settingsButton
            }
            .padding(.horizontal)
            
            
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
                Text("Create your Avatar!")
                    .frame(width: 200, height: 50)
                    .foregroundColor(.black)
            )
        }
    }
    
    private var wardrobeButton: some View {
        NavigationLink(destination: WardrobeView(hideNavBar: $hideNavBar, avatarSnapshot: $avatarSnapshot, enviroInt: $enviroInt, oldS3Key: avatarS3Key, apiService: APIService).navigationBarTitleDisplayMode(.inline)
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
        NavigationLink(destination: ProfileSettingsView(APIService: APIService, hideNavBar: $hideNavBar).navigationBarTitleDisplayMode(.inline)
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
        HStack(spacing: 15) {
            NavigationLink(destination: FollowersListView(APIService: APIService)) {
                VStack {
                    Text("\(followers)")
                        .font(.headline)
                    Text("Followers")
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
            
            NavigationLink(destination: FollowingListView(APIService: APIService)) {
                VStack {
                    Text("\(following)")
                        .font(.headline)
                    Text("Following")
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .padding(.bottom, 10)
    }
    

    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            socialButtons
            Text(bio)
                .padding(.all, 13)
                .background(Color("Black0").opacity(0.3))
                .cornerRadius(15, corners: [.topRight, .bottomRight])
                .frame(minWidth: UIScreen.main.bounds.width * 0.3, maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .topLeading)
                .font(.system(size: UIScreen.main.bounds.width * 0.035))
                .foregroundColor(Color("LightGray"))
        }
    }

    private var socialButtons: some View {
        HStack {
            namePlate
            Spacer()
            socialButton(imageName: "network")
            resumeButton(imageName: "list.bullet.clipboard.fill")
        }
        .frame(width: UIScreen.main.bounds.width)
        .padding(.top, 10)
    }

    private var namePlate: some View {
        ZStack {
            Image("NamePlate5")
                .resizable()
                .scaledToFit()
            Text(user.username)
                .font(.system(size: 18))
                .foregroundColor(Color("LightGray"))
                .padding(.trailing, 40)
        }
        .frame(height: 50)
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
        .padding(.trailing, 10)
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
            ResumeView(resume: resume, showResume: $showResume)
        }
    }
    
    private var refreshButton: some View {
        Button(action: fetchUserPosts) {
            HStack {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 16))
                Text("Refresh")
            }
            
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.green.opacity(0.9))
            .cornerRadius(8)
        }
    }

    private var userPostsScrollView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 16) {
                refreshButton
                
                ForEach(userPosts, id: \.id) { post in
                    UserBannerPostView(APIService: APIService, intVal: 1, userId: post.user_id)
                        .environmentObject(user)
                    
                    HStack {
                        Button(action: {
                            self.currentEditingPost = post
                            self.showEditPostModal = true
                        }) {
                            LazyVStack(alignment: .leading, spacing: 0) {
                                if let s3Key = post.s3_key?.String, post.s3_key?.Valid == true {
                                    PostContentView(s3_key: s3Key, bodyText: post.body, mediaType: MediaType(from: post.media))
                                } else {
                                    PostContentView(s3_key: nil, bodyText: post.body, mediaType: .none)
                                }
                            }
                        }
                        .padding([.leading, .trailing])
                        
                        Spacer()
                        
                        Button(action: {
                            deletePostConfirmation(postId: post.id)
                        }) {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                        }
                        .padding(.trailing, 10)
                    }

                    InteractionButtonMenu(
                        showCommentSection: $showCommentSection,
                        showingReportAlert: $showingReportAlert,
                        APIService: APIService,
                        postId: post.id,
                        likesCount: post.likes,
                        commentCount: post.comments,
                        userLiked: post.user_liked ?? false
                    )
                    .environmentObject(user)
                    .overlay(Rectangle().frame(height: 1, alignment: .bottom).foregroundColor(Color("LightGray").opacity(0.4)), alignment: .bottom)
                    
                    Spacer()
                }
            }
            .background(Color("GradientDark3"))
        }
        .sheet(isPresented: $showEditPostModal, onDismiss: {
            self.currentEditingPost = nil
        }) {
            EditPostView<APIService>(APIService: APIService, post: $currentEditingPost)
        }
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
        APIService.getUserProfile(for: user.username) { result in
            switch result {
            case .success(let profile):
                self.bio = profile.bio
                self.resume = profile.resume
                self.followers = profile.followers
                self.following = profile.following
            case .failure(let error):
                print("Error fetching user profile: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchUserSocials() {
        APIService.getUserSocials(for: user.username) { result in
            switch result {
            case .success(let socials):
                self.userSocials = socials
            case .failure(let error):
                print("Error fetching user's socials: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchUserPosts() {
        APIService.getUserPosts(for: user.username) { result in
            switch result {
            case .success(let posts):
                self.userPosts = posts
            case .failure(let error):
                print("Error fetching user's posts: \(error.localizedDescription)")
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
        APIService.deletePost(email: user.email, postId: postId) { result in
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
        
        return ProfileTabView<MockAPIService>(APIService: MockAPIService(), hideNavBar: .constant(false), showCommentSection: .constant(false))
            .environmentObject(testUser)
    }
}
