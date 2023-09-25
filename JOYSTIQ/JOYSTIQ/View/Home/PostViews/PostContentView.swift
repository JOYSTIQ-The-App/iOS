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
    
    //FROM CLIP POST View
//    @State private var player: AVPlayer? = nil
    @State private var videoURL: URL?
    
    var s3_key: String?
    var bodyText: String?
        
    private let s3Service = S3Service()
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            // Use the fetched videoURL to play the video
            if let url = videoURL {
                let player = AVPlayer(url: url)
                VideoPlayer(player: player)
                    .frame(width: UIScreen.main.bounds.width-40, height: 220)
                    .cornerRadius(10)
            }
          
            // Display body text if available
            if let bodyText = bodyText {
                Text(bodyText)
                    .font(.system(size: UIScreen.main.bounds.height * 0.017))
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
            }
          
            
        } //end VStack for video/image content and caption
        .padding(.top, 5)
        .onAppear {
            // Fetch the video URL only if s3_key is present
            if let key = s3_key {
                Task {
                    do {
                        // Fetch the video URL using Amplify
                        videoURL = try await Amplify.Storage.getURL(key: key)
                    } catch {
                        print("Error fetching video URL: \(error)")
                    }
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
        
        PostContentView(s3_key: nil, bodyText: "text")
            .background(Color("GradientDark"))
        
    }
}
