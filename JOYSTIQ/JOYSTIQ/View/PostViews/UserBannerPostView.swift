//
//  UserBannerPostView.swift
//  JOYSTIQ
//
//  Updated by Stephen Sottosanti on 10/31/23.
//

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
    var body: some View {
        HStack { //for avatar image, username, game, dot, timeSincePosted
            
            //for avatar image and username banner
            ZStack(alignment: .leading) {
                usernameBanner
                userAvatar
            }
            .padding(.leading, 10)
            
            //image of the game in the post
            gameLogoButton

            //dot between game and timeSincePosted
            Circle()
                .fill(Color.gray)
                .frame(width: ScreenUtil.width * 0.006, height: ScreenUtil.width * 0.006)
                .padding(.leading, 0)
            
            Text(timeSincePosted)
                .font(.system(size: ScreenUtil.height * 0.012))
                .foregroundColor(.gray)
            
            Spacer()
        }
        .frame(width: ScreenUtil.width, height: ScreenUtil.height / 18)
        .onAppear{
            loadData()
        }
    }
    
    // MARK: - Subviews
    private var userAvatar: some View {
        Group {
            if let image = avatarSnapshot {
                
                /* TEST image
                Image("photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaleEffect(3)
                    .frame(width: ScreenUtil.height / 21, height: ScreenUtil.height / 21)
                    .offset(y: ScreenUtil.height / 19)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white, Color.gray]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color("LightGray"), lineWidth: 1.5))
                    .zIndex(1)
                */
                
                Image(uiImage: image)
                    .resizable()
                     .aspectRatio(contentMode: .fill)
                     .scaleEffect(3)
                     .frame(width: ScreenUtil.height / 21, height: ScreenUtil.height / 21)
                     .offset(y: ScreenUtil.height / 19)
                     .background(
                         LinearGradient(
                             gradient: Gradient(colors: [Color.white, Color.gray]),
                             startPoint: .top,
                             endPoint: .bottom
                         )
                     )
                     .clipShape(Circle())
                     .overlay(Circle().stroke(Color("LightGray"), lineWidth: 1.5))
                     .zIndex(1)
                 
            } else {
                Image(systemName: "person.fill")
                    .frame(width: ScreenUtil.height / 21, height: ScreenUtil.height / 21)
                    .scaleEffect(1.5)
                    .foregroundColor(Color.gray)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white, Color.gray]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color("LightGray"), lineWidth: 1.5))
                    .zIndex(1)
            }
        }
    }
    
    private var usernameBanner: some View {
        NavigationLink(destination: OtherProfileView(apiService: apiService, profileUsername: username)) {
            Text(username)
                .font(.system(size: ScreenUtil.height * 0.016))
                .foregroundColor(.black)
                .padding(.leading, ScreenUtil.width * 0.05) //inner padding
                .padding(.trailing, ScreenUtil.width * 0.03) //inner padding
                .frame(height: ScreenUtil.height * 0.035)
                .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(10)
                .zIndex(0)
                .padding(.leading, ScreenUtil.width * 0.07) //outer padding from left
        }
    }
    
    private var gameLogoButton: some View {
        Button(action: {}) {
            if let imageName = GameData.gamesDictionary[game],
               UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: ScreenUtil.height * 0.04, height: ScreenUtil.height * 0.04)
                    .cornerRadius(ScreenUtil.height * 0.01)
            } else {
                Text(game)
                    .foregroundColor(.purple)
                    .font(.system(size: ScreenUtil.height * 0.02))
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
        UserBannerPostView<MockAPIService>(apiService: MockAPIService(), game: "Valorant", username: "Username", avatarS3Key: S3Key(String: "someKey1", Valid: false), createdAt: "2023-09-19T19:58:06.499746Z")
            .background(Color("GradientDark3"))
    }
}








