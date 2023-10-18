//
//  PlayerViewModel.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/17/23.
//

import SwiftUI
import AVKit

class PlayerManager: ObservableObject {
    private var players: [AVPlayer] = []
    private let maxPlayers: Int
    private let lock = NSLock()
    
    init(maxPlayers: Int = 10) {
        self.maxPlayers = maxPlayers
    }
    
    func getPlayer(url: URL) -> AVPlayer {
        lock.lock()
        defer { lock.unlock() }
        
        if let player = players.popLast() {
            player.replaceCurrentItem(with: AVPlayerItem(url: url))
            return player
        }
        
        return AVPlayer(url: url)
    }
    
    func returnPlayer(_ player: AVPlayer) {
        lock.lock()
        defer { lock.unlock() }
        
        if players.count < maxPlayers {
            players.append(player)
        }
    }
}

