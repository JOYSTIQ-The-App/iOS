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


struct VideoPlayerTESTS_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerTESTS()
    }
}
