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

    // MARK: - Body
    var body: some View {
        content
            .padding(.top, 5)
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
            if playerManager.currentlyPlayingID == s3_key.String, playerManager.isReady {
                VideoPlayer(player: playerManager.player)
                    .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.24)
                    .cornerRadius(10)
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
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.24)
                    .cornerRadius(10)
            } else {
                Color.black
                    .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.24)
                    .cornerRadius(10)
            }
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
        }
    }

    private var screenWithPlayButton: some View {
        ZStack {
            if let url = thumbnailURL {
                WebImage(url: url)  // Using SDWebImageSwiftUI's WebImage to load the image from the URL
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.24)
                    .cornerRadius(10)
            } else {
                Color.black
                    .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.24)
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
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(Color.white.opacity(0.7))
        }
    }

    // MARK: - Image Viewing Vars
    /*
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
     */
    
    
    @State private var isFullScreen = false
    @State private var imageOffset: CGSize = .zero
    @State private var dragOffset: CGFloat = 0
    
    private var imageContent: some View {
       
            
        VStack(alignment: .center) {
            imagePostView
                .fullScreenCover(isPresented: $isFullScreen) {
                    imageFullScreenViewer
                }
        }
        .frame(width: UIScreen.main.bounds.width)
            
        
    }
    
    
    
    
    private var imagePostView: some View {
   
 
        ZStack(alignment: .bottomTrailing) {
            
            if let url = imageURL {
               
                WebImage(url: url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .frame(minHeight: UIScreen.main.bounds.height * 0.2, maxHeight: UIScreen.main.bounds.height * 0.3)
                    .cornerRadius(10)
                    .zIndex(0)
            
            } else {
                EmptyView()
            }
            

            
            Button(action: {
                self.isFullScreen.toggle()
            }) {
            
                ZStack() {
                    
                    Image(systemName: "app")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color("LightGray"))
                    
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(Color("LightGray"))
                    
                }
                .background(Color.black.opacity(0.6))
                .cornerRadius(10)
                
                                           
            }
            .frame(width: 35, height: 35)
            .padding(.bottom, 10)
            .padding(.trailing, 10)
            .zIndex(1)
            
 
            
        }
            
      
        
    }
    
    private var imageFullScreenViewer: some View {
            
        VStack(spacing: 0) {
            actionMenu
            Spacer()
          
            if let url = imageURL {
                WebImage(url: url)
                    .resizable()
                    .scaledToFit()
            } else {
                EmptyView()
            }
            
            
            Spacer()
        } //end VStack
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
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
    
    private var actionMenu: some View {
        HStack { //for close and ...
            
            Spacer()
            
            Button(action: {
                isFullScreen = false
            }) {
            
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("LightGray"))
                                   
            }
            
        }//end HStack for action menu
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 30)
        .padding(.top, 30)
    }
    
    
    
    
    
    
    //MARK: - Caption Vars
    private var textContent: some View {
        Group {
            if bodyText != "" {
                Text(bodyText)
                    .font(.system(size: UIScreen.main.bounds.height * 0.017))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
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
            PostContentView(s3_key: S3Key(String: "someKey1", Valid: false), bodyText: "This caption is to serve=]", mediaType: .none)
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color("GradientDark"))
        .environmentObject(PlayerManager())
    }
}
