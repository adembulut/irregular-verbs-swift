import Foundation
import AVFoundation

@MainActor
final class AudioPlayerService: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var currentPlayingURL: URL?
    
    func playAudio(from url: URL) {
        // Stop current playback if any
        stop()
        
        do {
            // Configure audio session to play even when device is in silent mode
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
            currentPlayingURL = url
            
            // Reset when finished
            DispatchQueue.main.asyncAfter(deadline: .now() + (audioPlayer?.duration ?? 0)) {
                self.isPlaying = false
                self.currentPlayingURL = nil
            }
        } catch {
            print("Error playing audio: \(error)")
            isPlaying = false
            currentPlayingURL = nil
        }
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        currentPlayingURL = nil
    }
}

