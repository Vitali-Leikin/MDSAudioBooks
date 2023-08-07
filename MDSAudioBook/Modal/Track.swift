//
//  Track.swift
//  MDSAudioBook
//
//  Created by vitali on 21.07.2023.
//

import Foundation


class Track: Codable{

    let index: Int?
    let title: String
    let author: String?
    let date: String?
    let previewURL: URL
    var downloaded: Bool? = false
    var playMusicStatus: Bool? = true
    
    var timerPlay: Float? = 0.0

    init(index: Int, title: String, author: String, date: String, previewURL: URL) {
        self.index = index
        self.title = title
        self.author = author
        self.date = date
        self.previewURL = previewURL
    }
    
}




