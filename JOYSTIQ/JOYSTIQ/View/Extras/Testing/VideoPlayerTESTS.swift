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
    
    var body: some View {
        
        VStack(spacing: 0) { //for video/image content and caption
            
      
            if let videoURL = Bundle.main.url(forResource: "TrimmedClip2", withExtension: "mp4") {
                
            let player = AVPlayer(url: videoURL)
           
                
            VideoPlayer(player: player).onAppear{player.play()}
                    .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.24)
                    .cornerRadius(10)
                
                    
            } else {
               
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.24)
                    .cornerRadius(10)
            }
          
          
            
        } //end VStack for video/image content and caption
        .padding(.top, 5)
     
        
    } //end body
        
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
            let videoURL = URL(string: "TrimmedClip1.mp4") // Replace with your video URL
            player = AVPlayer(url: videoURL!)
        }
    }
}



struct VideoPlayerTESTS_Previews: PreviewProvider {
    static var previews: some View {
        //VideoPlayerTESTS()
        CustomVideoPlayerView()
    }
}
