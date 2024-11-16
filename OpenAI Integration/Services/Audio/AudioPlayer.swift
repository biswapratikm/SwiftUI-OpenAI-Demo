//
//  AudioPlayer.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 04/11/24.
//


import AVFoundation
import CoreGraphics
import Combine


/// AudioPlayer handles the playback of audio files using AVAudioPlayer.
/// It supports playing, pausing, stopping, and seeking within the audio track.
/// It also configures the necessary audio session for playback and generates waveform heights for visualization.

class AudioPlayer: NSObject, AVAudioPlayerDelegate, ObservableObject {
    private var audioPlayer: AVAudioPlayer?

    // URL of the audio file to be played
    var audioURL: URL? {
        didSet {
            guard let url = audioURL else { return }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = self
            } catch {
                print("Failed to initialize audio player: \(error)")
            }
        }
    }

    var playbackCompletion: (() -> Void)?
    @Published var isPlaying: Bool = false // Playback status
    var isPaused: Bool = false             // Pause status

    var currentTime: TimeInterval { audioPlayer?.currentTime ?? 0 } // Current playback time
    var duration: TimeInterval { audioPlayer?.duration ?? 1 }       // Total duration of audio

    // Seeks playback to the specified time
    func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = time
    }

    // Configures the audio session for playback
    private func configureAudioSessionForPlayback() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session for playback: \(error)")
        }
    }

    // Starts or resumes playback
    func play(completion: @escaping (Error?) -> Void) {
        guard let _ = audioPlayer else {
            completion(NSError(domain: "AudioPlayer", code: -1, userInfo: [NSLocalizedDescriptionKey: "No audio player available"]))
            return
        }

        if isPaused {
            audioPlayer?.play()
            isPlaying = true
            isPaused = false
            return
        }

        configureAudioSessionForPlayback()
        isPlaying = true
        audioPlayer?.play()
        playbackCompletion = {
            self.isPlaying = false
            self.isPaused = false
            completion(nil)
        }
    }

    // Pauses playback
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        isPaused = true
    }

    // Stops playback and clears the audio player
    func stopPlayback() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        isPaused = false
    }

    // Clears the playback state and resets the audio URL
    func clearPlayback() {
        stopPlayback()
        audioURL = nil
    }

    // Delegate method: Called when playback finishes
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        isPaused = false
        playbackCompletion?()
        playbackCompletion = nil
    }

    // Generates waveform heights for visualization
    func getWaveformHeights(barCount: Int) -> [CGFloat] {
        var heights: [CGFloat] = []

        guard let audioURL = audioURL,
              let audioFile = try? AVAudioFile(forReading: audioURL),
              let buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: UInt32(audioFile.length)),
              let channelData = buffer.floatChannelData?.pointee else {
            return Array(repeating: 10.0, count: barCount)
        }

        try? audioFile.read(into: buffer)
        let step = Int(audioFile.length) / barCount

        for i in stride(from: 0, to: Int(audioFile.length), by: step) {
            let startIndex = i
            let endIndex = min(i + step, Int(audioFile.length))
            var sumOfSquares: Float = 0.0

            for j in startIndex..<endIndex {
                let value = channelData[j]
                sumOfSquares += value * value
            }

            let rms = sqrt(sumOfSquares / Float(endIndex - startIndex))
            let height = CGFloat(min(max(rms * 200, 4), 24))
            heights.append(height)
        }

        return heights
    }
}

