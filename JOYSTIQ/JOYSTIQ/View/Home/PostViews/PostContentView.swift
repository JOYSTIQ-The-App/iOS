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
                    VStack(alignment: .center){
                        VideoPlayer(player: player)
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.25)
                            .cornerRadius(10)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    //expand on tap gesture
                }
            case .photo:
                if let url = imageURL {
                    VStack(alignment: .center) {
                        WebImage(url: url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                            .frame(maxHeight: UIScreen.main.bounds.height * 0.25)
                            .cornerRadius(10)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    //expand on tap gesture
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
        
        LazyVStack(alignment: .center, spacing: 0) {
            PostContentView(s3_key: nil, bodyText: "This caption is to serve as a sample caption of more than one line!", mediaType: .none)
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color("GradientDark"))
    }
}
