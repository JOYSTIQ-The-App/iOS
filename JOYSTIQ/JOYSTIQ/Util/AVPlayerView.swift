//
//  AVPlayerView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/16/23.
//

import SwiftUI
import AVFoundation

struct AVPlayerView: UIViewRepresentable {
    let url: URL
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<AVPlayerView>) { }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        playerLayer.frame = view.bounds
        player.play()
        
        return view
    }
}
