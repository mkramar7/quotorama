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
    
    var body: some View {
        VStack {
            Text("Swipe left to show next quote")
            
            AVTutorialPlayerView()
            
            Divider()
                .background(Color.white)
                .padding(.bottom, 10)
            Button("OK") {
                self.viewShown = false
            }
        }
        .frame(width: 250, height: 200)
        .padding(20)
        .background(Color(UIColor.darkGray))
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}

struct AVTutorialPlayerView: UIViewControllerRepresentable {
    private var player: AVPlayer {
        AVPlayer(url:  Bundle.main.url(forResource: "swipe_left", withExtension: "mp4")!)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        let playerController = uiViewController as! AVPlayerViewController
        playerController.player = player
        playerController.player?.play()
        playerController.showsPlaybackControls = false
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { _ in
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return AVPlayerViewController()
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView(viewShown: .constant(true))
    }
}
