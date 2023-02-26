//
//  Extension GameVC+AVFoundation.swift
//  SamePictureGame
//
//  Created by 김지수 on 2022/12/14.
//

import AVFoundation
import UIKit

extension GameSceneViewController {
    
//    func playMusic() {
//        let url = Bundle.main.url(forResource: "mapleBgm", withExtension: "mp3")
//        if let url = url {
//            do {
//                bgmPlayer = try AVAudioPlayer(contentsOf: url)
//                bgmPlayer?.prepareToPlay()
//                bgmPlayer?.numberOfLoops = -1
//                bgmPlayer?.play()
//            }
//            catch {
//                print(error)
//            }
//        }
//    }
//
//    @objc func musicToggle() {
//        if isMusicEnable == true {
//            bgmPlayer?.setVolume(0, fadeDuration: 0.5)
//        } else {
//            bgmPlayer?.setVolume(1, fadeDuration: 0.5)
//        }
//        self.isMusicEnable.toggle()
//    }
//
    func playFlipSound() {
        let url = Bundle.main.url(forResource: "flip", withExtension: "wav")
        if let url = url {
            do {
                sfxPlayer = try AVAudioPlayer(contentsOf: url)
                sfxPlayer?.prepareToPlay()
                sfxPlayer?.play()
            }
            catch {
                print(error)
            }
        }
    }
//
//    func stopBGM() {
//        bgmPlayer?.stop()
//    }
}

