//
//  AudioPlaybackView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 03/11/24.
//


import SwiftUI

struct AudioPlaybackView: View {
    var audioURL: URL
    @StateObject private var viewModel = AudioPlaybackViewModel() // ViewModel for audio playback
    var autoPlay: Bool = false

    var body: some View {
        VStack {
            HStack(spacing: 12) {
                
                // Playback control button
                Button(action: viewModel.togglePlayback) {
                    Image(systemName: viewModel.isPlaying ? Strings.pauseImage : Strings.playImage)
                        .font(.title)
                        .foregroundColor(AppColors.blue)
                }
                
                // Waveform slider
                WaveformSliderView(
                    progress: Binding(
                        get: { Double(viewModel.currentProgressIndex) / Double(viewModel.waveformHeights.count) },
                        set: { newValue in
                            viewModel.seekToIndex(Int(newValue * Double(viewModel.waveformHeights.count)))
                        }
                    ),
                    waveformHeights: viewModel.waveformHeights,
                    currentProgressIndex: viewModel.currentProgressIndex,
                    seekToIndex: viewModel.seekToIndex
                )
                
                // Playback duration
                Text(viewModel.duration)
                    .font(.caption)
                    .foregroundColor(AppColors.gray)
                    .frame(width: 27)
            }
            .padding(10)
            .background(AppColors.backgroundGray)
            .cornerRadius(15)
        }
        .onAppear {
            viewModel.setAudioURL(audioURL)
            if autoPlay {
                viewModel.togglePlayback()
            }
        }
        .onChange(of: audioURL) {
            viewModel.setAudioURL(audioURL)
        }
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(title: Text(Strings.error),
                  message: Text(viewModel.errorMessage),
                  dismissButton: .default(Text(Strings.ok)))
        }
    }
}


#Preview {
    AudioPlaybackView(
        audioURL: URL(string: "https://example.com/audio.m4a")!,
        autoPlay: false
    )
}


