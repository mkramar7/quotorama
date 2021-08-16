//
//  FooterView.swift
//  Quotorama
//
//  Created by Marko Kramar on 16.03.2021..
//

import SwiftUI

struct FooterView: View {
    @State private var musicIsPlaying = false
    @State private var themesViewShown = false
    
    var body: some View {
        HStack {
            ActionButtonView(text: "Themes", icon: "paintpalette") { themesViewShown.toggle() }
                .padding([.bottom, .leading], 20)
                .sheet(isPresented: $themesViewShown) {
                    ThemesView()
                }
            
            Spacer()
            
            ActionButtonView(text: musicIsPlaying ? "Stop playing" : "Ambient music", icon: musicIsPlaying ? "stop.fill" : "play.fill", action: toggleMusicPlaying)
                .padding([.bottom, .trailing], 20)
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
