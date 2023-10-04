//
//  VideoPlayerView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 7/21/23.
//
// Takes in content (image/video), caption (optional)
//
import SwiftUI
import AVKit
import Amplify
import SDWebImageSwiftUI

struct PostContentView: View {
    
    @State private var videoURL: URL?
    @State private var imageURL: URL?
    
    var s3_key: String?
    var bodyText: String?
    var mediaType: MediaType
    
    private let s3Service = S3Service()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            switch mediaType {
            case .video:
                if let url = videoURL {
                    let player = AVPlayer(url: url)
                    VideoPlayer(player: player)
                        .frame(width: UIScreen.main.bounds.width-40, height: 220)
                        .cornerRadius(10)
                }
            case .photo:
                if let url = imageURL {
                    WebImage(url: url)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width-40, height: 220)
                        .cornerRadius(10)
                }
            case .none:
                EmptyView()
            }
            
            if let bodyText = bodyText {
                Text(bodyText)
                    .font(.system(size: UIScreen.main.bounds.height * 0.017))
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
            }
            
        }
        .padding(.top, 5)
        .onAppear {
            if mediaType != .none {
                if let key = s3_key {
                    Task {
                        do {
                            let url = try await Amplify.Storage.getURL(key: key)
                            switch mediaType {
                            case .video:
                                videoURL = url
                            case .photo:
                                imageURL = url
                            case .none:
                                break
                            }
                        } catch {
                            print("Error fetching URL: \(error)")
                        }
                    }
                } else {
                    print("Expected s3_key for media type \(mediaType) but none found.")
                }
            }
        }
    }
}


struct PostContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        PostContentView(s3_key: nil, bodyText: "text", mediaType: .none)
            .background(Color("GradientDark"))
        
    }
}
