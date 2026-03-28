//
//  LoopingVideoPlayer.swift
//  ilo sitelen
//
//  Created by koteczek on 3/26/26.
//
// this is far too fucking involved for my original goal of getting rid of the black bars


import SwiftUI
import AVKit

struct LoopingVideoPlayer: View {
    let filename: String
    
    @State private var player: AVPlayer?
    
    var body: some View {
        Group {
            if let player = player {
                CroppedVideoPlayerView(player: player)
            } else {
                Color.clear
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            setupPlayer()
        }
        .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { notification in
            guard let item = notification.object as? AVPlayerItem, item == player?.currentItem else { return }
            player?.seek(to: .zero)
            player?.play()
        }
    }
    
    private func setupPlayer() {
        let name = (filename as NSString).deletingPathExtension
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp4") else {
            print("Could not find video file: \(filename)")
            return
        }
        
        let newPlayer = AVPlayer(url: url)
        newPlayer.isMuted = true
        newPlayer.actionAtItemEnd = .none
        
        newPlayer.play()
        self.player = newPlayer
    }
}

// MARK: - Custom UIKit Player View for Cropping
struct CroppedVideoPlayerView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> PlayerUIView {
        let view = PlayerUIView()
        view.player = player
        view.playerLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        uiView.player = player
    }
}

class PlayerUIView: UIView {
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
