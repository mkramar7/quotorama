//
//  TutorialView.swift
//  Quotorama
//
//  Created by Marko Kramar on 10.03.2021..
//

import SwiftUI
import AVKit

struct TutorialView: View {
    @Binding var viewShown: Bool
    
    let player = AVPlayer(url:  Bundle.main.url(forResource: "swipe_left", withExtension: "mp4")!)
    
    var body: some View {
        VStack {
            Text("Swipe left to show next quote")
                .padding(.top, 10)
            
            AVTutorialPlayerView(player: player)
                .frame(width: 125, height: 125)
            
            Divider()
                .background(Color.white)
            
            Button("OK") {
                self.viewShown = false
            }
            .foregroundColor(.accentColor)
            .padding(.bottom, 10)
        }
        .frame(width: 250)
        .foregroundColor(.black)
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct AVTutorialPlayerView: UIViewControllerRepresentable {
    var player: AVPlayer
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        let playerController = uiViewController as! AVPlayerViewController
        playerController.view.backgroundColor = UIColor.white
        playerController.player = player
        playerController.player?.play()
        playerController.showsPlaybackControls = false
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: CMTime.zero)
            player.play()
        }
        return AVPlayerViewController()
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView(viewShown: .constant(true))
    }
}
