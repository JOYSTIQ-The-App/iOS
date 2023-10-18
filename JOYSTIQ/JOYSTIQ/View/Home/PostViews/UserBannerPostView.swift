//
//  UserBannerPostView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 5/4/23.
//
// Takes in profile picture (png), username (string), game name (string ?)
//

import SwiftUI
import Amplify

struct UserBannerPostView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    var apiService: APIServiceType
    var game: String
    var username: String
    var avatarS3Key: S3Key
    
    @State private var avatarSnapshot: UIImage?
    
    // MARK: - Body
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                userAvatar
                usernameBanner
            }
            .frame(width: UIScreen.main.bounds.width * 0.4, height: 50)
            .padding(.leading, 10)
            
            gameLogoButton
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color("GradientDark3"))
        .onAppear{
            loadData()
        }
    }
    
    // MARK: - View Components
    private var userAvatar: some View {
        if let image = avatarSnapshot {
            return AnyView(
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 45, height: 60)
                    .scaleEffect(2.8)
                    .offset(y: 46)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white, Color.gray]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color("LightGray"), lineWidth: 2))
                    .zIndex(1)
            )
        } else {
            return AnyView(
                //default picture if user does not have avatar
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
            )
        }
    }
    
    private var usernameBanner: some View {
        Text(username)
            .font(.system(size: 15))
            .foregroundColor(.black)
            .frame(width: UIScreen.main.bounds.width * 0.30, height: 30)
            .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(10)
            .zIndex(0)
            .padding(.leading, 30)
    }
    
    private var gameLogoButton: some View {
        Button(action: {}) {
            Text(game)
                .foregroundColor(.green)
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
        UserBannerPostView<MockAPIService>(apiService: MockAPIService(), game: "Valorant", username: "SampleUsername", avatarS3Key: S3Key(String: "someKey1", Valid: false))
    }
}









