//
//  QuotoramaUtil.swift
//  Quotorama
//
//  Created by Marko Kramar on 05.03.2021..
//

import Foundation
import SwiftUI
import AVFoundation
import MediaPlayer

class Util {
    static let APP_STORE_APP_URL = "apps.apple.com/app/quotorama/id1553081598"
    static let ATTRIBUTION_TEXT = "\"Art of Silence - by Uniq\" is under a Creative Commons license (Creative Commons – International Recognition 4.0 – CC BY 4.0)"
    static let THEMES = [("forest_road", "railroad"), ("space", "forest"), ("sunflower", "splash"), ("clouds", "desert")]
    
    static func appFont(_ size: CGFloat) -> Font {
        Font.custom("Futura", size: size)
    }
}

class MusicPlayer {
    static let shared = MusicPlayer()
    var audioPlayer: AVAudioPlayer!
    
    func play() {
        audioPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "music", withExtension: "mp3")!)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func stop() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
    }
}
