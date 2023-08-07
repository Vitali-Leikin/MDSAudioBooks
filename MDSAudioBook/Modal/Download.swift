//
//  Download.swift
//  MDSAudioBook
//
//  Created by vitali on 25.07.2023.
//

import Foundation

class Download {
  //
  // MARK: - Variables And Properties
  //
  var isDownloading = false
  var progress: Float = 0
  var resumeData: Data?
  var task: URLSessionDownloadTask?
  var track: Track

  //
  // MARK: - Initialization
  //
  init(track: Track) {
    self.track = track
  }
}
