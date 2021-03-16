//
//  FooterView.swift
//  Quotorama
//
//  Created by Marko Kramar on 16.03.2021..
//

import SwiftUI

struct FooterView: View {
    @State private var musicIsPlaying = false
    
    var body: some View {
        HStack {
            ActionButtonView(text: musicIsPlaying ? "Stop playing" : "Ambient music", icon: musicIsPlaying ? "play" : "music.note", action: toggleMusicPlaying)
                .padding([.bottom, .leading], 20)
            
            Spacer()
        }
    }
    
    func toggleMusicPlaying() {
        if musicIsPlaying {
            MusicPlayer.shared.stop()
            musicIsPlaying = false
        } else {
            MusicPlayer.shared.play()
            musicIsPlaying = true
        }
    }
}
