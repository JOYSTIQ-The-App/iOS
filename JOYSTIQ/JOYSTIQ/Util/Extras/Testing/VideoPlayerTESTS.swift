//
//  VideoPlayerTESTS.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/7/23.
//

import SwiftUI
import AVKit

struct VideoPlayerTESTS: View {
    
    @State private var player = AVPlayer()
    @State private var videoSize: CGSize = .zero
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            if let videoURL = Bundle.main.url(forResource: "portaitVideo", withExtension: "mp4") {
                
                let player = AVPlayer(url: videoURL)
                
                VideoPlayer(player: player)
                    .onAppear {
                        player.play()
                        self.getVideoSize(url: videoURL)
                    }
                    .frame(width: ScreenUtil.width * 0.99, height: self.getAdjustedHeight())
                    .cornerRadius(5)
                
            } else {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: ScreenUtil.width * 0.99, height: UIScreen.main.bounds.height * 0.24)
                    .cornerRadius(10)
            }
        }
        .padding(.top, 5)
     
    } // end body
    
    private func getVideoSize(url: URL) {
        let asset = AVAsset(url: url)
        let tracks = asset.tracks(withMediaType: .video)
        if let track = tracks.first {
            self.videoSize = track.naturalSize.applying(track.preferredTransform)
            self.videoSize = CGSize(width: abs(self.videoSize.width), height: abs(self.videoSize.height))
        }
    }
    
    private func getAdjustedHeight() -> CGFloat {
        let aspectRatio = videoSize.height / videoSize.width
        let width = ScreenUtil.width * 0.99
        let height = width * aspectRatio
        let minHeight = ScreenUtil.height * 0.245
        let maxHeight = ScreenUtil.height * 0.7
        
        return min(max(height, minHeight), maxHeight)
    }
}



struct CustomVideoPlayerView: View {
    @State private var isFullscreen = false
    @State private var player: AVPlayer?

    var body: some View {
        ZStack {
            if isFullscreen {
                VideoPlayer(player: player)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VideoPlayer(player: player)
                    .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.24)
                    .cornerRadius(10)
            }

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isFullscreen.toggle()
                    }) {
                        Image(systemName: isFullscreen ? "arrow.down.right.square.fill" : "arrow.up.left.square.fill")
                            .font(.title)
                            .padding()
                            .background(Color.red.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.trailing)
                }

                if !isFullscreen {
                    // Other custom controls can be added here
                }
            }
        }
        .onAppear {
            let videoURL = URL(string: "landscapeVideo") // Replace with your video URL
            player = AVPlayer(url: videoURL!)
        }
    }
}



struct VideoPlayerTESTS_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerTESTS()
        //CustomVideoPlayerView()
    }
}
