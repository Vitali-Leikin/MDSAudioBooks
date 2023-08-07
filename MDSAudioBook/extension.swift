//
//  extension.swift
//  MDSAudioBook
//
//  Created by vitali on 31.07.2023.
//

import UIKit


// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()

        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }

        for  item in searchResults{
            if item.title == searchBar.text!{
                searchResults = [item]
                tableView.reloadData()
            } else{
            }
        }

        tableView.reloadData()
        tableView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      //  view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
      //  view.removeGestureRecognizer(tapRecognizer)
        searchResults = tempArray
        tableView.reloadData()
        searchBar.text = ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        searchResults = tempArray
        
        if searchText.isEmpty{
            searchResults = tempArray
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }else{
           let x = searchResults.map({$0.title}).filter({$0.contains(searchText)})
            print(x)
            var searchTempArray: [Track] = []
            for  item in searchResults{
                for searchItem in x{
                    if item.title == searchItem{
                        searchTempArray.append(item)

                    }
                }
                
            }
            searchResults = searchTempArray
            tableView.reloadData()
           
        }
      //  searchResults = tempArray
//        if searchBar.text?.count == 0 {
//            searchResults = tempArray
//            tableView.reloadData()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
    }
    
    

}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tableCellReg.rawValue, for: indexPath) as! TableViewCell

        cell.delegate = self
    
//
        let track = searchResults[indexPath.row]
        let destinationURL =  FManager.shared.localFilePath(for: track.previewURL)

        if FManager.shared.isFileExist(destinationPath: destinationURL.path){
            track.downloaded = true
            cell.configureCell(track: track, download: downloadService.activeDownloads[track.previewURL], downloaded: track.downloaded ?? true, btnState: track.playMusicStatus ?? true, timer: track.timerPlay ?? 0.0)
        }else{
            cell.configureCell(track: track, download: downloadService.activeDownloads[track.previewURL], downloaded: track.downloaded ?? false, btnState: true, timer: track.timerPlay ?? 0.0)
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //When user taps cell, play the local file, if it's downloaded.
        
        let track = searchResults[indexPath.row]
        
        if track.downloaded ?? false{
            AudioPlayer.shared.playDownload(track: track)
            present(AudioPlayer.shared.controller, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let track = searchResults[indexPath.row]
        let destinationURL = FManager.shared.localFilePath(for: track.previewURL)
        
        if FManager.shared.isFileExist(destinationPath: destinationURL.path){
            return true
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let track = searchResults[indexPath.row]
        let destinationURL = FManager.shared.localFilePath(for: track.previewURL)
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            do{
                try FileManager.default.removeItem(at: destinationURL)
                let temp =  self.searchResults.remove(at: indexPath.row)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.searchResults.insert(temp, at: indexPath.row)
                    self.searchResults[indexPath.row].downloaded = false
                    tableView.reloadData()
                }
            } catch{
                print("Error remove", error.localizedDescription)
            }
            
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.endUpdates()
        }
    }
    
}

// MARK: - TrackCellDelegate


extension ViewController: TrackCellDelegate {
    func timer(_ cell: TableViewCell, timer: Float) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            
            track.timerPlay = timer
            print("sssss = ",timer)
            reload(indexPath.row)
            tableView.reloadData()
         print("timer MUSIC")
        }
        
        
    }
    
    func stopMusicTaped(_ cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            track.playMusicStatus = false
            
            for item in searchResults{
                if item.index == track.index{
                    print("item = ",item)
                }else{
                    item.playMusicStatus = true
                }
            }
            
            tableView.reloadData()
         //   reload(indexPath.row)
         print("STOP MUSIC")
        }
    }
    
    func playMusicTaped(_ cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            track.playMusicStatus = true
          //  reload(indexPath.row)
            tableView.reloadData()
         print("PLAY MUSIC")
        }
    }
    
    func cancelTapped(_ cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.cancelDownload(track)
            reload(indexPath.row)
            print("cancel")
        }
    }
    
    func downloadTapped(_ cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.startDownload(track)
            reload(indexPath.row)
            print("dowload")
            
        }
    }
    
    func pauseTapped(_ cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.pauseDownload(track)
            reload(indexPath.row)
            print("pause")
            
        }
    }
    
    func resumeTapped(_ cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.resumeDownload(track)
            reload(indexPath.row)
            print("resume")
            
        }
    }
}

// MARK: - URLSessionDelegate


extension ViewController: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                completionHandler()
            }
        }
    }
}


// MARK: - URLSessionDownloadDelegate

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        // 1
        guard let sourceURL = downloadTask.originalRequest?.url else {
            return
        }
        
        let download = downloadService.activeDownloads[sourceURL]
        downloadService.activeDownloads[sourceURL] = nil
        
        // 2
        let destinationURL = FManager.shared.localFilePath(for: sourceURL)
        
        // 3
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            download?.track.downloaded = true
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
        
        // 4
        if let index = download?.track.index {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        // 1
        guard
            let url = downloadTask.originalRequest?.url,
            let download = downloadService.activeDownloads[url]  else {
            return
        }
        
        // 2
        download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        // 3
        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
        
        // 4
        DispatchQueue.main.async {
            if let trackCell = self.tableView.cellForRow(at: IndexPath(row: download.track.index ?? 0,
                                                                       section: 0)) as? TableViewCell {
                trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
            }
        }
    }
}
