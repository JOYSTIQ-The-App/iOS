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

struct PostContentView: View {
    
    @State public var intVal: Int
    //FROM CLIP POST View
//    @State private var player: AVPlayer? = nil
    @State private var videoURL: URL?
        
    private let s3Service = S3Service()
    
    
    var body: some View {
        
        VStack(spacing: 0) { //for video/image content and caption
            
        
//            if let videoURL = Bundle.main.url(forResource: "TrimmedClip" + String(intVal), withExtension: "mp4") {
//
//            let player = AVPlayer(url: videoURL)
//
//                VideoPlayer(player: player)
//                    .frame(width: UIScreen.main.bounds.width-40, height: 220)
//                    .cornerRadius(10)
//
//
//            } else {
//
//                Rectangle()
//                    .fill(Color.gray)
//                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 250)
//            }
            // Use the player to play the video
//            if let unwrappedPlayer = player {
//                VideoPlayer(player: unwrappedPlayer)
//                    .frame(width: UIScreen.main.bounds.width-40, height: 220)
//                    .cornerRadius(10)
//            } else {
//                Rectangle()
//                    .fill(Color.gray)
//                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 250)
//            }
            
            // Use the fetched videoURL to play the video
            if let url = videoURL {
                let player = AVPlayer(url: url)
                VideoPlayer(player: player)
                    .frame(width: UIScreen.main.bounds.width-40, height: 220)
                    .cornerRadius(10)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 250)
            }
          
            
           
            
          
//            Rectangle()
//                .fill(Color.black.opacity(0.5))
//                .frame(width: UIScreen.main.bounds.width * 0.9, height: 220)
//                .cornerRadius(10)
            
            
            
            
            
            // Caption
            Text("This is a sample caption of a few lines of text. Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                .font(.system(size: UIScreen.main.bounds.height * 0.017))
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
          
            
        } //end VStack for video/image content and caption
        .padding(.top, 5)
        .onAppear {
            Task {
                do {
                    // Fetch the video URL using Amplify
                    videoURL = try await Amplify.Storage.getURL(key: "TrimmedClip3.mp4")
                } catch {
                    print("Error fetching video URL: \(error)")
                }
            }
        }
        
        
//        .onAppear {
//            Task {
//                do {
//                    // Download the video data using Amplify
//                    let downloadTask = Amplify.Storage.downloadData(key: "TrimmedClip3.mp4")
//                    for await progress in await downloadTask.progress {
//                        print("Progress: \(progress)")
//                    }
//                    let data = try await downloadTask.value
//
//                    // Write the data to a temporary file
//                    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
//                    try data.write(to: tempURL)
//
//                    // Use the temporary file URL to play the video
//                    player = AVPlayer(url: tempURL)
//                } catch {
//                    print("Error downloading and playing video: \(error)")
//                }
//            }
//        }
     
        
    } //end body
}

struct PostContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        PostContentView(intVal: 1)
            .background(Color("GradientDark"))
        
    }
}
