//
//  ViewController.swift
//  MDSAudioBook
//
//  Created by vitali on 20.07.2023.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    // MARK: - @IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - property
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: K.idSession.rawValue)
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    //    lazy var tapRecognizer: UITapGestureRecognizer = {
    //        var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
    //        return recognizer
    //    }()
  
    lazy var tempArray: [Track] = []
    lazy var searchResults: [Track] = []
    let downloadService = DownloadService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.tableCell.rawValue, bundle: nil), forCellReuseIdentifier: K.tableCellReg.rawValue)
        
        loadJson()
        downloadService.downloadsSession = downloadsSession
        tempArray = searchResults
    }
    
    
    
    // MARK: - func
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func reload(_ row: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    func loadJson(){
        if let safeData = JSONNetworkManager.shared.loadJson(){
            searchResults = safeData
        }
    }
}


