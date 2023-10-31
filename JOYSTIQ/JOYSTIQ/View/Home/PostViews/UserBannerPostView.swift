//
//  UserBannerPostView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 5/4/23.
//
// Takes in profile picture (png), username (string), game name (string ?)
//

//    private var userAvatar: some View {
//        if let image = avatarSnapshot {
//            return AnyView(
//                Image(uiImage: image)
//                    .resizable()
//                    .frame(width: 45, height: 60)
//                    .scaleEffect(2.8)
//                    .offset(y: 46)
//                    .background(
//                        LinearGradient(
//                            gradient: Gradient(colors: [Color.white, Color.gray]),
//                            startPoint: .top,
//                            endPoint: .bottom
//                        )
//                    )
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color("LightGray"), lineWidth: 2))
//                    .zIndex(1)
//            )
//        } else {
//            return AnyView(
//                //default picture if user does not have avatar
//                Image(systemName: "person.fill")
//                    .frame(width: 45, height: 45)
//                    .scaleEffect(1.5)
//                    .foregroundColor(.gray)
//                    .background(
//                        LinearGradient(
//                            gradient: Gradient(colors: [Color.white, Color.gray]),
//                            startPoint: .top,
//                            endPoint: .bottom
//                        )
//                    )
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                    .zIndex(1)
//            )
//        }
//    }

import SwiftUI
import Amplify

struct UserBannerPostView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    var apiService: APIServiceType
    var game: String
    var username: String
    var avatarS3Key: S3Key
    var createdAt: String
    
    @State private var avatarSnapshot: UIImage?
    @State private var isAvatarFullScreen = false
    @State private var avatarScale: CGFloat = 1.0
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }
    
    var creationDate: Date? {
        return dateFormatter.date(from: createdAt)
    }
    
    var timeSincePosted: String {
        guard let date = creationDate else { return "" }
        
        let now = Date()
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: date, to: now)
        if let days = components.day, days > 0 {
            return "\(days)d ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours)h ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes)m ago"
        } else {
            return "Just now"
        }
    }
    
    // MARK: - Body
//    var body: some View {
//        HStack {
//            ZStack(alignment: .leading) {
//                userAvatar
//                usernameBanner
//            }
//            .frame(width: UIScreen.main.bounds.width * 0.4, height: 50)
//            .padding(.leading, 10)
//            
//            gameLogoButton
//            
//            Circle()
//                .fill(Color.gray)
//                .frame(width: 5, height: 5)
//                .padding(.leading, 5)
//            
//            Text(timeSincePosted)
//                .font(.system(size: 14))
//                .foregroundColor(.gray)
//            
//            Spacer()
//        }
//        .frame(width: UIScreen.main.bounds.width)
//        .background(Color("GradientDark3"))
//        .onAppear{
//            loadData()
//        }
//    }
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                userAvatar

                if !isAvatarFullScreen { // Only show the username banner if the avatar is not in full screen mode
                    usernameBanner
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.4, height: 50)
            .padding(.leading, 10)
            
            gameLogoButton.opacity(isAvatarFullScreen ? 0 : 1) // Hide the game logo button when the avatar is full screen

            Circle()
                .fill(Color.gray)
                .frame(width: 5, height: 5)
                .opacity(isAvatarFullScreen ? 0 : 1) // Hide the circle when the avatar is full screen
                .padding(.leading, 5)
            
            Text(timeSincePosted)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .opacity(isAvatarFullScreen ? 0 : 1) // Hide the time text when the avatar is full screen
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color("GradientDark3"))
        .onAppear{
            loadData()
        }
    }
    
    // MARK: - Subviews
//    private var userAvatar: some View {
//        Group {
//            if let image = avatarSnapshot {
//                Image(uiImage: image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill) // Keeps the image aspect ratio but fills the given space
//                    .frame(width: isAvatarFullScreen ? UIScreen.main.bounds.width/2 : 45, height: isAvatarFullScreen ? UIScreen.main.bounds.width/2 : 60) // Assumes square aspect ratio for fullscreen.
//                    .background(
//                        LinearGradient(
//                            gradient: Gradient(colors: [Color.white, Color.gray]),
//                            startPoint: .top,
//                            endPoint: .bottom
//                        )
//                    )
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color("LightGray"), lineWidth: 2))
//                    .zIndex(5) // Ensure avatar is on top
//                    .onTapGesture {
//                        withAnimation {
//                            self.isAvatarFullScreen.toggle()
//                        }
//                    }
//            } else {
//                Image(systemName: "person.fill")
//                    .frame(width: 45, height: 45)
//                    .scaleEffect(1.5)
//                    .foregroundColor(.gray)
//                    .background(
//                        LinearGradient(
//                            gradient: Gradient(colors: [Color.white, Color.gray]),
//                            startPoint: .top,
//                            endPoint: .bottom
//                        )
//                    )
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                    .zIndex(1)
//            }
//        }
//    }
    
    private var userAvatar: some View {
        Group {
            if let image = avatarSnapshot {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill) // Keeps the image aspect ratio but fills the given space
                    .frame(width: isAvatarFullScreen ? UIScreen.main.bounds.width/2 : 45, height: isAvatarFullScreen ? UIScreen.main.bounds.width/2 : 60) // Assumes square aspect ratio for fullscreen.
                    .scaleEffect(isAvatarFullScreen ? 1.0 : 2.8) // Zoom in when not fullscreen
                    .offset(y: isAvatarFullScreen ? 0 : 46) // Offset only when not fullscreen
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white, Color.gray]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color("LightGray"), lineWidth: 2))
                    .zIndex(5) // Ensure avatar is on top
                    .onTapGesture {
                        withAnimation {
                            self.isAvatarFullScreen.toggle()
                        }
                    }
            } else {
                Image(systemName: "person.fill")
                    .frame(width: 45, height: 45)
                    .scaleEffect(1.5)
                    .foregroundColor(.gray)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white, Color.gray]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .zIndex(1)
            }
        }
    }
    
    private var usernameBanner: some View {
        NavigationLink(destination: OtherProfileView(apiService: apiService, profileUsername: username)) {
            Text(username)
                .font(.system(size: 15))
                .foregroundColor(.black)
                .frame(width: UIScreen.main.bounds.width * 0.30, height: 30)
                .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(10)
                .zIndex(0)
                .padding(.leading, 30)
        }
    }
    
    private var gameLogoButton: some View {
        Button(action: {}) {
            if let imageName = GameData.gamesDictionary[game],
               UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35)
                    .cornerRadius(10)
            } else {
                Text(game)
                    .foregroundColor(.purple)
            }
        }
    }
    
    // MARK: - Functions
    private func loadData() {
        if avatarS3Key.Valid {
            fetchAvatarImage(s3Key: avatarS3Key.String)
        }
    }
    
    private func fetchAvatarImage(s3Key: String) {
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
                }
            } catch {
                print("Error fetching avatar image: \(error)")
            }
        }
    }
}

// MARK: - Preview
struct UserBannerPostView_Previews: PreviewProvider {
    static var previews: some View {
        UserBannerPostView<MockAPIService>(apiService: MockAPIService(), game: "Valorant", username: "SampleUsername", avatarS3Key: S3Key(String: "someKey1", Valid: false), createdAt: "2023-09-19T19:58:06.499746Z")
    }
}









