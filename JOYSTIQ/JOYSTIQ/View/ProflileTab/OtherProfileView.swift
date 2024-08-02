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
    
    @State private var showSocials = false
    @State private var avatarSnapshot: UIImage?
    @State private var enviroInt: Int = 0
    @State private var accMode = true //determines accolade display
    
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
    @State private var isFollowingUser = false
    @State private var avatarS3Key: S3Key = S3Key(String: "", Valid: false)

    @State private var userSocials: [String: String]?
    @State private var isLoading: Bool = false
    @State private var isLoadingAvatar: Bool = false
    @State private var showFollowButton = true
    //for sliding profile up
    @State private var isExpanded = false
    @State private var viewOffset: CGFloat = 0

    // MARK: - Body
    var body: some View {
        ZStack {
            
            userProfile
            
            if (isExpanded) {
                VStack(spacing: 0) {
                    chevronButtonExpanded
                    userPostsView
                }
                .padding(.bottom, ScreenUtil.height * 0.04)
                
            }
            
            if showSocials {
                socialsModal
            }
            
            if isLoading {
                loadingOverlay
            }
        }
        .accentColor(Color(.label))
    }

    // MARK: - Subviews
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // To ensure it covers the entire screen
    }
    
    private var userProfile: some View {

            VStack(spacing: 0) {
                
                avatarSection
                    .zIndex(3)
                
                AccoladeBanner(accMode: $accMode)
                    .offset(y: -ScreenUtil.height * 0.01)
                    .zIndex(2)
                
                attributeButtons
                    .zIndex(1)
                
                bioSection
                
                Spacer()
                
                chevronButton
                    .padding(.bottom, ScreenUtil.height * 0.08)
                

            } //end profileView
            .edgesIgnoringSafeArea([.top, .bottom])
            .onAppear {
               if user.username == profileUsername {
                   showFollowButton = false
               } else {
                   fetchIsFollowing()
               }
               
               fetchUserProfile()
           }
            .offset(y: viewOffset)
            .background( Color("GradientDark3"))
    }
    
    //MARK: - Avatar Section Subviews
    private var avatarSection: some View { //env, avatar, name plate
        ZStack(alignment: .bottom) { //to push wardrobe & settings buttons to bottom of avatar frame
            
            ZStack(alignment: .center) {
                avatarBackground
                avatarImage
            }
            
            namePlate
                .offset(x: (-ScreenUtil.width * 0.31), y: -ScreenUtil.height * 0.02)
        }
    }

    private var avatarBackground: some View {
        Image(enviroInt == 1 ? "bedroomEnv" : "defaultEnv")
            .resizable()
            .frame(width: ScreenUtil.width, height: ScreenUtil.height * 0.4)
            .edgesIgnoringSafeArea(.top)
            .aspectRatio(contentMode: .fill)
            .shadow(color: Color.black, radius: 6, x: 0, y: 4)
    }

    private var avatarImage: some View {
        if let image = avatarSnapshot {
            return AnyView(
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1.4)
                    .frame(width: ScreenUtil.width * 0.5, height: ScreenUtil.height * 0.32)
                    .padding(.top, ScreenUtil.height * 0.05)
                    .shadow(color: Color.black.opacity(0.6), radius: 1, x: 0, y: 2)
                    .allowsHitTesting(false) // Ignore touch events, obstructs acc banner scrolling
            )
        } else if isLoadingAvatar {
            return AnyView(
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            )
        } else {
            return AnyView(
                Text("No Avatar Yet")
                    .frame(width: 200, height: 50)
                    .foregroundColor(.black)
            )
        }
    }
    
    private var namePlate: some View {
        ZStack(alignment: .center) {
            Image("NamePlate5")
                .resizable()
                .scaledToFill()
            Text(profileUsername) //shrinks as name length increases
                .font(.system(size: (ScreenUtil.height * 0.023) - (CGFloat(user.username.count) * 0.3)))
                .foregroundColor(Color("LightGray"))
                .padding(.trailing, ScreenUtil.width * 0.06)
        }
        .frame(width: ScreenUtil.width * 0.4, height: ScreenUtil.height * 0.01)
        .shadow(color: Color.black, radius: 6, x: 2, y: 4)
        .shadow(color: Color.white.opacity(0.5), radius: 2, x: 0, y: -1)
    }
    
    //MARK: - Profile Attributes
    private var attributeButtons: some View { // socials, followers, accolade button
        HStack(spacing: 0) {
            
            if showFollowButton {
                followButton
                    .padding(.trailing, ScreenUtil.width * 0.03)
            }
            else {
                Spacer()
            }
            
            
            socialButton
                .padding(.trailing, ScreenUtil.width * 0.03)
            
            followersButtons
                .padding(.trailing, ScreenUtil.width * 0.03)
            
            accButton
            
        }
        .padding(.leading, isFollowingUser ? ScreenUtil.width * 0.09 : ScreenUtil.width * 0.12)
    }
    
    private var followButton: some View {
        Button(action: {followButtonAction()},
        
        label: {
            if (isFollowingUser) {
                HStack (spacing: 0) {
                    Text("Following")
                        .foregroundColor(Color("LightGray"))
                        .font(.system(size: ScreenUtil.width * 0.031))
                    Image(systemName: "checkmark")
                        .resizable()
                        .foregroundColor(Color("LightGray"))
                        .frame(width: ScreenUtil.width * 0.025, height: ScreenUtil.height * 0.011)
                        .padding(.leading, ScreenUtil.width * 0.015)
                }
                .padding(.vertical, ScreenUtil.height * 0.012)
                .padding(.horizontal, ScreenUtil.width * 0.02)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color("GradientDark3"))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.white.opacity(0.4), lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 2)
            }
            else {
                Text("Follow")
                    .foregroundColor(Color("GradientDark"))
                    .font(.system(size: ScreenUtil.width * 0.038))
                    .padding(.vertical, ScreenUtil.height * 0.012)
                    .padding(.horizontal, ScreenUtil.width * 0.04)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color("LightGray"))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.white.opacity(0.4), lineWidth: 2)
                    )
                    .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 2)
            }
        })
    }
    
    private var accButton: some View {
        Button(action: {
            accMode.toggle()
        },
       label: {
            Image(systemName: accMode ? "gamecontroller.fill" : "medal.fill")
                .resizable()
                .scaledToFit()
                .frame(width: ScreenUtil.width * 0.11, height: ScreenUtil.width * 0.11)
                .padding(ScreenUtil.width * 0.02)
                .padding(.top, ScreenUtil.height * 0.01)
                .foregroundColor(Color("LightGray"))
                .background(Color("Black0"))
                .cornerRadius([.bottomLeading, .bottomTrailing], 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.6), radius: 5, x: 0, y: 2)
                .offset(y: -ScreenUtil.height * 0.013) //tuck behind acc banner
                .padding(.trailing, ScreenUtil.width * 0.02)
        })
    }
    
    private var followersButtons: some View {
        HStack(spacing: 10) {
            NavigationLink(destination: FollowersListView(apiService: apiService, username: profileUsername)) {
                VStack {
                    Text("\(followers)")
                        .font(.headline)
                        .foregroundColor(Color.white)
                    Text("Followers")
                        .font(.system(size: ScreenUtil.height * 0.011))
                        .foregroundColor(Color.white)
                }
                .frame(width: ScreenUtil.width * 0.16, height: ScreenUtil.height * 0.06)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
            
            NavigationLink(destination: FollowingListView(apiService: apiService, username: profileUsername)) {
                VStack {
                    Text("\(following)")
                        .font(.headline)
                        .foregroundColor(Color.white)
                    Text("Following")
                        .font(.system(size: ScreenUtil.height * 0.011))
                        .foregroundColor(Color.white)
                }
                .frame(width: ScreenUtil.width * 0.16, height: ScreenUtil.height * 0.06)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                
            }
        }
    }
    
    private var bioSection: some View {
        Group {
            if (!bio.isEmpty) {
                Text(bio)
                    .padding(.all, 13)
                    .background(Color("Black0").opacity(0.6))
                    .cornerRadius(10)
                    .frame(width: ScreenUtil.width * 0.9, alignment: .center)
                    .font(.system(size: ScreenUtil.width * 0.04))
                    .foregroundColor(Color.white)
                    .padding(.top, ScreenUtil.height * 0.01)
                    .opacity(isExpanded ? 0 : 1)
            }
            else {
                EmptyView()
            }
        }
    }

    private var socialButton: some View {
        Button(action: {
            showSocials.toggle()
        }) {
            Image(systemName: "person.crop.rectangle.stack")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(Color("LightGray"))
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color("LightGray").opacity(0.4), lineWidth: 2)
                )
        }
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
    
    private var chevronButton: some View{
        HStack {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                    viewOffset = -ScreenUtil.height
                }
            },
                   
                   label: {
                Image(systemName: isExpanded ? "chevron.compact.down" : "chevron.compact.up")
                    .resizable()
                    .frame(width: ScreenUtil.width * 0.1, height: ScreenUtil.height * 0.02)
                    .foregroundColor(Color("LightGray"))
                
            })
        }
        .frame(width: ScreenUtil.width, height: ScreenUtil.height * 0.06)
        .background(Color.black.opacity(0.4))
        .overlay(
            Rectangle()
                .frame(height: 0.4) // Border height
                .foregroundColor(Color.gray.opacity(0.6)) // Border color
                .frame(maxHeight: .infinity, alignment: .top),
            alignment: .top
        )
        .zIndex(2)
        //.offset(y: viewOffset)
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
                viewOffset = -ScreenUtil.height * 0.75
            }
        }
        .opacity(isExpanded ? 0 : 1)
        .disabled(isExpanded)
    }
    
    private var chevronButtonExpanded: some View{
        HStack {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                    viewOffset = 0
                }
            },
                   
                   label: {
                Image(systemName: "chevron.compact.down")
                    .resizable()
                    .frame(width: ScreenUtil.width * 0.1, height: ScreenUtil.height * 0.02)
                    .foregroundColor(Color("LightGray"))
                
            })
        }
        .frame(width: ScreenUtil.width, height: ScreenUtil.height * 0.06)
        .background(Color.black.opacity(0.3))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.6))
                .frame(maxHeight: .infinity, alignment: .bottom),
            alignment: .top
        )
        .zIndex(2)
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
                viewOffset = 0
            }
        }
    }
    
    // MARK: - User's content
    private var userPostsView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(userPosts) { post in
                    PostView(
                        apiService: apiService,
                        post: post
                    )
                    .environmentObject(user)
                    .environmentObject(playerManager)
                    
                }
            }
        }
        .background(Color("GradientDark3"))
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
        let testUser = User(email: "testEmail@example.com", username: "ApicalArtist")
        
        return OtherProfileView<MockAPIService>(apiService: MockAPIService(), profileUsername: "Apical")
            .environmentObject(testUser)
            .environmentObject(PlayerManager())
    }
}
