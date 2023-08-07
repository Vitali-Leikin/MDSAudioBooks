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
    var backgroundSessionCompletionHandler: (() -> Void)?
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


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

        AudioPlayer.shared.controller.player = nil
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // We need to connect it again when app is entering foreground.
        AudioPlayer.shared.controller.player = AudioPlayer.shared.player
    }

}
    
    

