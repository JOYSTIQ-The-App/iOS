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

struct PostContentView: View {
    
    @State public var intVal: Int
    //FROM CLIP POST View
    @State private var player = AVPlayer()
    
    var body: some View {
        
        VStack(spacing: 0) { //for video/image content and caption
            
        /*
            if let videoURL = Bundle.main.url(forResource: "TrimmedClip" + String(intVal), withExtension: "mp4") {
                
                let player = AVPlayer(url: videoURL)
                
                VideoPlayer(player: player)
                    .frame(width: UIScreen.main.bounds.width-40, height: 220)
                    .cornerRadius(10)
                
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 250)
            }
          */
            
            
            Rectangle()
                .fill(Color.black.opacity(0.4))
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 220)
                .cornerRadius(10)
          
            
            // Caption
            Text("This is a sample caption of a few lines of text. Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.9))
                .padding(.vertical, 15)
                .padding(.horizontal, 20)
          
            
        } //end VStack for video/image content and caption
        .padding(.top, 5)
     
        
    } //end body
}

struct PostContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        PostContentView(intVal: 1)
            .background(Color("GradientDark"))
        
    }
}
