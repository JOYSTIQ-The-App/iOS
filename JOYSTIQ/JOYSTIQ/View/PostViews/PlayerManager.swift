//
//  PlayerViewModel.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/17/23.
//

import AVKit
import Combine

class PlayerManager: ObservableObject {
    @Published var player: AVPlayer = AVPlayer()
    @Published var currentlyPlayingID: String? = nil
    @Published var isReady: Bool = false
    private var subscriptions = Set<AnyCancellable>()

    func playMedia(at url: URL, id: String) {
        currentlyPlayingID = nil
        currentlyPlayingID = id
        // Create an asset from the URL
        let asset = AVAsset(url: url)

        // Create a player item with the asset and specify the keys we want to be preloaded
        let playerItem = AVPlayerItem(
            asset: asset,
            automaticallyLoadedAssetKeys: [.tracks, .duration, .commonMetadata]
        )

        // Observe the status of the player item
        playerItem.publisher(for: \.status)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                switch status {
                case .readyToPlay:
                    // Ready to play. Here you can trigger any UI changes or controls to be shown/hidden
                    self?.isReady = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self?.player.play() // Starts playback once ready
                    }
                case .failed:
                    // Handle the failure, maybe update the UI to show an error state or retry
                    break
                default:
                    break
                }
            }
            .store(in: &subscriptions)

        // Set the player item to the player
        player.replaceCurrentItem(with: playerItem)

    }

    func pause() {
        player.pause()
    }
}


