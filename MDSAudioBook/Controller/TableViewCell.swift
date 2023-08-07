//
//  TableViewCell.swift
//  MDSAudioBook
//
//  Created by vitali on 20.07.2023.
//

import UIKit
import AVKit

protocol TrackCellDelegate {
    func cancelTapped(_ cell: TableViewCell)
    func downloadTapped(_ cell: TableViewCell)
    func pauseTapped(_ cell: TableViewCell)
    func resumeTapped(_ cell: TableViewCell)
    func playMusicTaped(_ cell: TableViewCell)
    func stopMusicTaped(_ cell: TableViewCell)
    func timer(_ cell: TableViewCell, timer: Float)
}



class TableViewCell: UITableViewCell {
    
    // MARK: - property
    
    var delegate: TrackCellDelegate?
    var track: Track?
    private var checkBtn = false
    private var checkBtnPlay = true
    
    // MARK: - @IBOutlet

    @IBOutlet weak var view: UIView!
    @IBOutlet weak private var downloadBtnOutlet: UIButton!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var cancelButton: UIButton!
    @IBOutlet weak private var downloadButton: UIButton!
    @IBOutlet weak private var pauseButton: UIButton!
    @IBOutlet weak private var progressLabel: UILabel!
    @IBOutlet weak private  var progressView: UIProgressView!
    @IBOutlet weak var imageViewLeft: UIImageView!
    @IBOutlet weak var playPauseBtnOutlet: UIButton!
    
//    var probably: Float = 0.0{
//        willSet{
//         //   print(probably)
//        }
//        didSet{
//
//        }
//    }

    // MARK: - @IBAction

    @IBAction func cancelTapped(_ sender: UIButton) {
        delegate?.cancelTapped(self)
    }
    
    @IBAction func downloadTapped(_ sender: UIButton) {
        delegate?.downloadTapped(self)
    }

    @IBAction func pauseTapped(_ sender: UIButton) {
        
        if checkBtn{
            delegate?.pauseTapped(self)
            print("pause = ",checkBtn)
            checkBtn = !checkBtn
            
        }else{
            delegate?.resumeTapped(self)
            print("resume = ",checkBtn)
            checkBtn = !checkBtn
        }

    }

    
    @IBAction func playPauseBtnPressed(_ sender: UIButton) {
        if checkBtnPlay{
            delegate?.stopMusicTaped(self)
            checkBtn = false
            playMusic()
        }else{
            delegate?.playMusicTaped(self)
            
            checkBtn = true
            stopPlay()
        }
    }
    

    // MARK: - func

    func playMusic(){
        print("PLAY")
        if let safeTrack = track{
            AudioPlayer.shared.playDownloadWithoutContrl(track: safeTrack)
           tpd()
            playPauseBtnOutlet.setImage(UIImage(systemName: "pause.rectangle"), for: .normal)
            progressView.isHidden = false
        }
    }
    

    func tpd(){
        let interval = CMTime(value: 1, timescale: 2)
        AudioPlayer.shared.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [self] (progressTime) in

            let seconds = CMTimeGetSeconds(progressTime)

            if let duration = AudioPlayer.shared.player?.currentItem?.duration{
                let durationSecond = CMTimeGetSeconds(duration)
                self.delegate?.timer(self, timer: Float(seconds / durationSecond))
            }
        })
    }

    
    
    func stopPlay(){
        playPauseBtnOutlet.setImage(UIImage(systemName: "play.circle"), for: .normal)
        AudioPlayer.shared.player?.pause()
    }
    
    
    func configureCell(track: Track, download: Download?, downloaded: Bool, btnState: Bool, timer: Float){
        progressView.isHidden = false
        self.track = track
        checkBtnPlay = btnState
   
        let imageTitle = checkBtnPlay ? "play.circle" : "pause.rectangle"
        playPauseBtnOutlet.setImage(UIImage(systemName: imageTitle), for: .normal)
        titleLabel.text = "\(String(track.index! + 1)) - \(track.title) \n\(track.author!)"
        imageViewLeft.image = UIImage(named: "music_note_2")
        imageViewLeft.layer.cornerRadius = 10

        var showDownloadControls = false
        if let download = download {
            showDownloadControls = true
            
            checkBtn = download.isDownloading
            let title = download.isDownloading ? "pause.rectangle": "arrow.counterclockwise.icloud"
            
            pauseButton.setImage(UIImage(systemName: title), for: .normal)
            progressLabel.text = download.isDownloading ? "Downloading..." : "Paused"
        }
        
        playPauseBtnOutlet.isHidden = true
        pauseButton.isHidden = !showDownloadControls
        cancelButton.isHidden = !showDownloadControls
        progressView.isHidden = !showDownloadControls
        progressLabel.isHidden = !showDownloadControls
        
        selectionStyle = downloaded ? UITableViewCell.SelectionStyle.gray : UITableViewCell.SelectionStyle.none
        
        downloadButton.isHidden = downloaded || showDownloadControls
        
        if downloadButton.isHidden && pauseButton.isHidden {
            downloadButton.setTitle("PLAY", for: .focused)
            playPauseBtnOutlet.isHidden = false
        }
    }
    
    
    func updateDisplay(progress: Float, totalSize : String) {
        self.progressView.progress = progress
        self.progressLabel.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
    }
    
}





