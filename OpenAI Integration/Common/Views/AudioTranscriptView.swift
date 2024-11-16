//
//  AudioTranscriptView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 13/11/24.
//


import SwiftUI

struct AudioTranscriptView: View {
    let audioURL: URL
    let transcript: String
    let isFullWidth: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Audio playback
            AudioPlaybackView(audioURL: audioURL,
                              autoPlay: true)
            Divider()
            // Transcript bubble
            ChatBubble(text: transcript,
                       isUser: false,
                       isFullWidth: isFullWidth,
                       italic: true)
        }
        .frame(maxWidth: isFullWidth ? .infinity : 270)
        .background(AppColors.backgroundGray)
        .cornerRadius(15)
    }
}

#Preview {
    let demoAudioURL = Bundle.main.url(forResource: "demo_audio", withExtension: "wav")!
    AudioTranscriptView(audioURL: demoAudioURL, transcript: "This is a mock transcript for debugging purposes. This is a mock transcript for debugging purposes. This is a mock transcript for debugging purposes.")
}
