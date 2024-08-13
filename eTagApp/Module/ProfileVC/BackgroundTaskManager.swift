//
//  BackgroundTaskManager.swift
//  eTagApp
//
//  Created by Macbook on 13/06/24.
//

import Foundation
import AVFAudio
import AVKit

class BackgroundTaskManager: NSObject {

    static let shared = BackgroundTaskManager()

    func startPlay() {
        audioPlayer.play()
    }

    func stopPlay() {
        audioPlayer.stop()
    }

    var audioPlayer: AVAudioPlayer!

    private override init() {
        super.init()

        do {
            // 设置后台模式和锁屏模式下依旧能够播放
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)

            let mp4Video = Bundle.main.url(forResource: "slience", withExtension: "mp3")
            try audioPlayer = AVAudioPlayer.init(contentsOf: mp4Video!)
            audioPlayer.volume = 0
            audioPlayer.numberOfLoops = -1
            print("成功")
        } catch {
            print(error)
        }
    }

}