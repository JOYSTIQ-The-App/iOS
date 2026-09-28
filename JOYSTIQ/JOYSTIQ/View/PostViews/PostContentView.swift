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
import Combine

struct PostContentView: View {
    // MARK: - Properties
    @EnvironmentObject var playerManager: PlayerManager
    
    var s3_key: S3Key
    var thumbnail: S3Key?
    var bodyText: String
    var mediaType: MediaType
    var vURL: URL? = nil
    var tURL: URL? = nil
    var imageURL: URL? = nil
    @State private var thumbnailURL: URL? = nil
    @State private var videoURL: URL? = nil
    @State private var player: AVPlayer? = nil
    @State private var isPlaying: Bool = false
    @State private var isLoading: Bool = false
    
    private let s3Service = S3Service()
    
    @State private var playerItemStatus: AVPlayerItem.Status = .unknown
    @State private var subscriptions: Set<AnyCancellable> = []
    
    //image vars - in testing
    @State private var isFullScreen = false
    @State private var imageOffset: CGSize = .zero
    @State private var dragOffset: CGFloat = 0

    // MARK: - Body
    var body: some View {
        content
            .padding(.vertical, ScreenUtil.height * 0.01)
            .onAppear {
                Task {
                    loadContentIfNecessary()
                }
            }
            .onDisappear(perform: handleOnDisappear)
            .onChange(of: playerManager.isReady) { isReady in
                if isReady {
                    isLoading = false
                }
            }
    }

    // MARK: - SubViews
    private var content: some View {
        VStack(alignment: .center, spacing: 10) {
            mediaContent
            textContent
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
    // MARK: - Video Views
    private var videoContent: some View {
        Group {
            if playerManager.currentlyPlayingID == s3_key.String, playerManager.isReady {
                VideoPlayer(player: playerManager.player)
                    .frame(width: ScreenUtil.width * 0.95, height: ScreenUtil.height * 0.25)
                    .cornerRadius(10)
                    .clipped()
                    .contentShape(Rectangle())
            } else if isLoading {
                screenWithLoading
            } else {
                screenWithPlayButton
            }
        }
        .asAnyView()
    }

    private var screenWithLoading: some View {
        ZStack {
            if let url = thumbnailURL {
                WebImage(url: url)  // Using SDWebImageSwiftUI's WebImage to load the image from the URL
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: ScreenUtil.width * 0.95, height: ScreenUtil.height * 0.25)
                    .clipped()
                    .contentShape(Rectangle())
                    .cornerRadius(10)
            } else {
                Color.black
                    .frame(width: ScreenUtil.width * 0.95, height: ScreenUtil.height * 0.25)
                    .cornerRadius(10)
                    .clipped()
                    .contentShape(Rectangle())
            }
            
            //ProgressView()
                //.progressViewStyle(CircularProgressViewStyle(tint: .white))
               // .scaleEffect(1.5)
        }
    }

    private var screenWithPlayButton: some View {
        ZStack {
            if let url = thumbnailURL {
                WebImage(url: url)  // Using SDWebImageSwiftUI's WebImage to load the image from the URL
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: ScreenUtil.width * 0.95, height: ScreenUtil.height * 0.25)
                    .clipped()
                    .contentShape(Rectangle())
                    .cornerRadius(10)
            } else {
                Color.black
                    .frame(width: ScreenUtil.width * 0.95, height: ScreenUtil.height * 0.25)
                    .cornerRadius(10)
            }
            playButtonOverlay
        }
    }

    private var playButtonOverlay: some View {
        Button(action: {
            isLoading = true
            if let videoURL = videoURL {
                playerManager.isReady = false
                playerManager.playMedia(at: videoURL, id: s3_key.String)
            }
        }) {
            Image(systemName: "play.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(Color.white.opacity(0.7))
        }
    }

    // MARK: - Image Views
    private var imageContent: some View {
        Group {
            if let url = imageURL {
                WebImage(url: url)
                 .resizable()
                 .aspectRatio(contentMode: .fill)
                 .frame(width: ScreenUtil.width * 0.95, height: ScreenUtil.height * 0.25)
                 .clipped()
                 .contentShape(Rectangle())
                 .cornerRadius(10)
                 .onTapGesture {
                     isFullScreen = true
                 }
                 .fullScreenCover(isPresented: $isFullScreen) {
                     imageFullScreenViewer
                 }
                 .id(isFullScreen)
            } else {
                EmptyView()
            }
        }
    }
    
    private var imageFullScreenViewer: some View {
        VStack(spacing: 0) {
            Spacer()
            if let url = imageURL {
                WebImage(url: url)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                EmptyView()
            }
            
            Spacer()
        } //end VStack
        .frame(width: ScreenUtil.width, height: ScreenUtil.height)
        .background(Color.black)
        .offset(y: max(-20, imageOffset.height + dragOffset))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    dragOffset = max(0, gesture.translation.height)
                }
                .onEnded { gesture in
                    if dragOffset > 100 {
                        withAnimation {
                            isFullScreen = false
                            imageOffset = .zero
                            dragOffset = 0
                        }
                    } else {
                        // Reset the dragOffset if the drag didn't reach the threshold
                        withAnimation {
                            dragOffset = 0
                        }
                    }
                }
        )
    }
    
    //MARK: - Caption View
    private var textContent: some View {
        Group {
            if bodyText != "" {
                Text(bodyText)
                    .padding(.horizontal, ScreenUtil.width * 0.05)
                    .frame(width: ScreenUtil.width, alignment: .leading)
                    .font(.system(size: ScreenUtil.height * 0.018))
                    .foregroundColor(.white)
            } else {
                EmptyView()
            }
        }
        .asAnyView()
    }

    // MARK: - Functions
    private func loadContentIfNecessary() {
        if mediaType == .video {
            if let thumbnail = tURL {
                thumbnailURL = thumbnail
            } else if let validKey = thumbnail?.String, thumbnail?.Valid == true {
                Task {
                    do {
                        thumbnailURL = try await Amplify.Storage.getURL(key: validKey)
                    } catch {
                        print("Failed to load thumbnail URL: \(error)")
                    }
                }
            } else {
                print("Failed to set thumbnail URL!")
            }
            
            if let video = vURL {
                videoURL = video
            } else if s3_key.Valid {
                Task {
                    do {
                        videoURL = try await Amplify.Storage.getURL(key: s3_key.String)
                    } catch {
                        print("Failed to load video URL: \(error)")
                    }
                }
            } else {
                print("Failed to set video URL!")
            }
        }
    }

    private func handleOnDisappear() {
        if playerManager.currentlyPlayingID == s3_key.String {
            playerManager.pause()
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
            PostContentView(s3_key: S3Key(String: "someKey1", Valid: false), 
                            bodyText: "Here's my caption its a long one but its a good one and its a few lines acutally",
                            mediaType: .video)
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color("GradientDark"))
        .environmentObject(PlayerManager())
    }
}
