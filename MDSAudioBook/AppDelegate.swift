//
//  AppDelegate.swift
//  MDSAudioBook
//
//  Created by vitali on 20.07.2023.
//

import UIKit
import AVKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
//    let tintColor =  UIColor(red: 242/255, green: 71/255, blue: 63/255, alpha: 1)
    var backgroundSessionCompletionHandler: (() -> Void)?
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

//    private func customizeAppearance() {
//      window?.tintColor = tintColor
//
//      UISearchBar.appearance().barTintColor = tintColor
//
//      UINavigationBar.appearance().barTintColor = tintColor
//      UINavigationBar.appearance().tintColor = UIColor.white
//
//      let titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : UIColor.white]
//      UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
//    }

    func applicationDidFinishLaunching(_ application: UIApplication) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error {
                print(error.localizedDescription)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Whenever the app is entering background
        // we have to disconnect the AVPlayer to prevent it from pausing.
        AudioPlayer.shared.controller.player = nil
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // We need to connect it again when app is entering foreground.
        AudioPlayer.shared.controller.player = AudioPlayer.shared.player
    }

}
    
    

