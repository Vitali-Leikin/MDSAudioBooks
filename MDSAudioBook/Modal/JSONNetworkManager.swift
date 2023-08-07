//
//  JSONNetworkManager.swift
//  MDSAudioBook
//
//  Created by vitali on 25.07.2023.
//

import Foundation

class JSONNetworkManager{
    
    static let shared = JSONNetworkManager()
    
    func loadJson() -> [Track]? {
        if let url = Bundle.main.url(forResource: K.dataJSON.rawValue, withExtension: K.jsonExten.rawValue) {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Track].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
}
