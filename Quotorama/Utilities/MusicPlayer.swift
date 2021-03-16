//
//  AudioPlayer.swift
//  Quotorama
//
//  Created by Marko Kramar on 16.03.2021..
//

import AVFoundation
import MediaPlayer

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
