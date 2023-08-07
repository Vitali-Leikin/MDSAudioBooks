//
//  FManager.swift
//  MDSAudioBook
//
//  Created by vitali on 25.07.2023.
//

import Foundation


class FManager{
    
    static let shared = FManager()
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    private init(){}
    
    func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    func isFileExist(destinationPath: String) -> Bool {
        return FileManager.default.fileExists(atPath: destinationPath)
    }
}
