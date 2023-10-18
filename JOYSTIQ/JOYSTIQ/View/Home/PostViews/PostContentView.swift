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
    // MARK: - Properties
    var s3_key: S3Key
    var bodyText: String
    var mediaType: MediaType
    var imageURL: URL? = nil
    var player: AVPlayer? = nil
    
    private let s3Service = S3Service()

    // MARK: - Body
    var body: some View {
        content
            .padding(.top, 5)
            .onDisappear(perform: handleOnDisappear)
    }

    // MARK: - SubViews
    private var content: some View {
        VStack(alignment: .center, spacing: 0) {
            mediaContent
            
            HStack {
                textContent
                Spacer()
            }
            
        }
    }
    
    private var mediaContent: some View {
        switch mediaType {
        case .video:
            return AnyView(videoContent)
        case .photo:
            return AnyView(imageContent)
        case .none:
            return AnyView(EmptyView())
        }
    }

    private var videoContent: some View {
        Group {
            if let player = player {
                VideoPlayer(player: player)
                    .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.24)
                    .cornerRadius(10)
            } else {
                EmptyView()
            }
        }
        .asAnyView()
    }

    private var imageContent: some View {
        Group {
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
            } else {
                EmptyView()
            }
        }
        .asAnyView()
    }

    private var textContent: some View {
        Group {
            if bodyText != "" {
                Text(bodyText)
                    .font(.system(size: UIScreen.main.bounds.height * 0.017))
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
            } else {
                EmptyView()
            }
        }
        .asAnyView()
    }

    // MARK: - Functions
    private func handleOnDisappear() {
        if let player = player {
            player.pause()
        }
    }
}

extension View {
    func asAnyView() -> AnyView {
        AnyView(self)
    }
}

// MARK: - Preview
struct PostContentView_Previews: PreviewProvider {
    static var previews: some View {
        LazyVStack(alignment: .center, spacing: 0) {
            PostContentView(s3_key: S3Key(String: "someKey1", Valid: false), bodyText: "This caption is to serve=]", mediaType: .video)
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color("GradientDark"))
    }
}
