//
//  AudioPlaybackViewModel.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 04/11/24.
//


import SwiftUI
import Combine

/// ViewModel for managing audio playback and waveform visualization.
class AudioPlaybackViewModel: ObservableObject {
    
    @Published var waveformHeights: [CGFloat] = []
    @Published var duration: String = ""
    
    let audioPlayer = AudioPlayer()
    @Published var isPlaying: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private var timer: Timer?
    @Published var currentProgressIndex: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Bind audio player's isPlaying state to view model
        audioPlayer.$isPlaying
            .assign(to: \.isPlaying, on: self)
            .store(in: &cancellables)
    }
    
    // Sets the audio URL and updates waveform and duration
    func setAudioURL(_ url: URL) {
        audioPlayer.clearPlayback()
        audioPlayer.audioURL = url
        updateWaveformAndDuration()
    }
    
    // Updates waveform heights and duration
    private func updateWaveformAndDuration() {
        guard let _ = audioPlayer.audioURL else { return }
        waveformHeights = audioPlayer.getWaveformHeights(barCount: 50)
        duration = formatDuration(audioPlayer.duration)
        currentProgressIndex = 0
    }
    
    // Formats audio duration to a string
    private func formatDuration(_ durationInSeconds: Double) -> String {
        let adjustedDuration = max(durationInSeconds, 1)
        let minutes = Int(adjustedDuration) / 60
        let seconds = Int(adjustedDuration) % 60
        return String(format: Strings.durationFormat, minutes, seconds)
    }
    
    // Toggles between play and pause
    func togglePlayback() {
        isPlaying ? pauseAudio() : playAudio()
    }
    
    // Plays the audio
    private func playAudio() {
        guard let _ = audioPlayer.audioURL else {
            errorMessage = Strings.noAudio
            showErrorAlert = true
            return
        }
        
        audioPlayer.play { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showErrorAlert = true
                    self?.errorMessage = Strings.playFailed + error.localizedDescription
                }
            }
        }
        startTimer()
    }
    
    // Pauses the audio
    private func pauseAudio() {
        audioPlayer.pause()
        stopTimer()
    }
    
    // Starts a timer to update progress
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            self?.updateCurrentProgress()
        }
    }
    
    // Stops the progress timer
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // Updates the current progress in waveform
    private func updateCurrentProgress() {
        let progress = audioPlayer.currentTime / audioPlayer.duration
        withAnimation {
            currentProgressIndex = Int(progress * Double(waveformHeights.count))
        }
    }
    
    // Seeks to a specific index in the waveform
    func seekToIndex(_ index: Int) {
        let newTime = (Double(index) / Double(waveformHeights.count)) * audioPlayer.duration
        audioPlayer.seek(to: newTime)
        currentProgressIndex = index
    }
}


