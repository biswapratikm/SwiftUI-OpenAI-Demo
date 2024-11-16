//
//  SpeechView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 23/10/24.
//

import SwiftUI
import AVFoundation

struct SpeechToTextView: View {
    
    // ViewModel for Speech-to-Text
    @StateObject private var viewModel: SpeechToTextViewModel
    
    // Initialize ViewModel with capability
    init(capability: Capability) {
        _viewModel = StateObject(wrappedValue: SpeechToTextViewModel(capability: capability))
    }
    
    var body: some View {
        VStack {
            
            // Instructional text when no recording is sent
            if viewModel.sentURL == nil {
                InstructionTextView(text: viewModel.capability.display)
            }
            
            // Content section
            VStack(alignment: .leading, spacing: 10) {
                
                // User Speech
                if let sentURL = viewModel.sentURL {
                    Text(Strings.userSpeech).font(.headline)
                    AudioPlaybackView(audioURL: sentURL)
                }
                
                // Loading indicator
                if viewModel.isLoading { LoadingView() }
                
                // Response Text
                if !viewModel.result.isEmpty {
                    Text(Strings.responseText).font(.headline)
                    ScrollView {
                        ChatBubble(text: viewModel.result, isUser: false)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            // Recording section
            RecordingView(audioURL: $viewModel.recordedURL,
                          isLoading: viewModel.isLoading,
                          viewModel: RecordingViewModel())
        }
        // Title and error handling
        .modifier(title: viewModel.capability.name,
                  showErrorAlert: $viewModel.showErrorAlert,
                  errorMessage: viewModel.errorMessage)
        // Send recording when available
        .onChange(of: viewModel.recordedURL) {
            if viewModel.recordedURL != nil {
                viewModel.sendRecording()
            }
        }
    }
}

#Preview {
    if let firstModel = openAIModels.first {
        if let firstCapability = firstModel.capabilities.first {
            SpeechToTextView(capability: firstCapability)
        }
    }
    
}
