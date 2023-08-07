//
//  AudioPlayer.swift
//  MDSAudioBook
//
//  Created by vitali on 25.07.2023.
//

import Foundation
import AVKit

class AudioPlayer: UIViewController{
    
    // MARK: - property
    static let shared = AudioPlayer()
    private var titleLabel: UILabel?

    var player: AVPlayer? = AVPlayer()
    var controller = AVPlayerViewController()

    // MARK: - func

    func playDownload(track: Track) {
        player = nil
        let url = FManager.shared.localFilePath(for: track.previewURL)
         player = AVPlayer(url: url)
        setTitle(str: "\(track.title) \n \((track.author ?? ""))" )
        controller.player = player
        player?.play()
    }
    
    func playDownloadWithoutContrl(track: Track) {
        let url = FManager.shared.localFilePath(for: track.previewURL)
         player = AVPlayer(url: url)
        setTitle(str: "\(track.title) \n \((track.author ?? ""))" )
        player?.play()
    }

    private func setTitle(str: String){
        titleLabel?.text = ""
        titleLabel = UILabel(frame: CGRect(x: self.view.center.x - (self.view.center.x / 2), y: 100, width: 200, height: 100))
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .center
        titleLabel?.text = str
        titleLabel?.textColor = .gray
        controller.contentOverlayView?.addSubview(titleLabel!)

    }
    
}
