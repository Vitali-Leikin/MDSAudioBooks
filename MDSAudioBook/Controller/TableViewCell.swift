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
    
    // static let identifier = "tableCell"
    var delegate: TrackCellDelegate?
    var track: Track?
    //    var timerCount: Float = 10.0
    private var checkBtn = false
    private var checkBtnPlay = true
   // var temp: Float = 0.0
  //  var decimal: Float = 0.0
    
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak private var downloadBtnOutlet: UIButton!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var cancelButton: UIButton!
    @IBOutlet weak private var downloadButton: UIButton!
    @IBOutlet weak private var pauseButton: UIButton!
    @IBOutlet weak private var progressLabel: UILabel!
    @IBOutlet weak private  var progressView: UIProgressView!
//    @IBOutlet weak private var playLabel: UILabel!
    @IBOutlet weak var imageViewLeft: UIImageView!
    
  //  @IBOutlet weak var stopPlayBtn: UIButton!
    @IBOutlet weak var playPauseBtnOutlet: UIButton!
    
  //  @IBOutlet weak var musicSlider: UISlider!
    
    //    private var url: String?
    //    private var resUrl: URL?
    
    //
    var probably: Float = 0.0{
        willSet{
         //   print(probably)
        }
        didSet{

        }
    }
//
//    var chk = true
//    var stopTimer: Float = 0.0
    
    
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
    
//    @IBAction func sliderMoveMusic(_ sender: UISlider) {
//
//
//        AudioPlayer.shared.player?.seek(to: CMTime(value: CMTimeValue(sender.value), timescale: 1))
//        print(sender.value)
//    }
    
    

     
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
     //   musicSlider.isHidden = false
        let interval = CMTime(value: 1, timescale: 2)
        AudioPlayer.shared.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [self] (progressTime) in

            let seconds = CMTimeGetSeconds(progressTime)

            if let duration = AudioPlayer.shared.player?.currentItem?.duration{
                let durationSecond = CMTimeGetSeconds(duration)
             //   print("durationSecond = ",durationSecond)
                probably = (Float(seconds / durationSecond))
                print(probably)
                self.delegate?.timer(self, timer: Float(seconds / durationSecond))
                
//                progressLabel.text = String(probably)
//                progressView.progress = probably
            }

        })

    }

    
    
    func stopPlay(){
        
      //  stopTimer = probably
        playPauseBtnOutlet.setImage(UIImage(systemName: "play.circle"), for: .normal)
        AudioPlayer.shared.player?.pause()
    }
    
    
    func configureCell(track: Track, download: Download?, downloaded: Bool, btnState: Bool, timer: Float){
        
        
        print("timerPPPP = ",timer)
        
        progressView.isHidden = false
        self.track = track
        checkBtnPlay = btnState
   
        let imageTitle = checkBtnPlay ? "play.circle" : "pause.rectangle"
        playPauseBtnOutlet.setImage(UIImage(systemName: imageTitle), for: .normal)
        titleLabel.text = "\(String(track.index! + 1)) - \(track.title) \n\(track.author!)"
        imageViewLeft.image = UIImage(named: "music_note_2")
        imageViewLeft.layer.cornerRadius = 10
        // Show/hide download controls Pause/Resume, Cancel buttons, progress info.
        var showDownloadControls = false
        // Non-nil Download object means a download is in progress.
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
        
//        progressView.isHidden = false// btnState
//        progressLabel.isHidden = false //btnState
        
        // If the track is already downloaded, enable cell selection and hide the Download button.
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





