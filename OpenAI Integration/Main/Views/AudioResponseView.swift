//
//  AudioChatView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 12/11/24.
//

import SwiftUI
import AVFoundation

struct AudioResponseView: View {
    
    // ViewModel for handling audio response
    @StateObject private var viewModel: AudioResponseViewModel
    
    // Initialize ViewModel with capability
    init(capability: Capability) {
        _viewModel = StateObject(wrappedValue: AudioResponseViewModel(capability: capability))
    }
    
    var body: some View {
        VStack {
            
            // Show instructions if no prompt
            if viewModel.userPrompt.isEmpty {
                InstructionTextView(text: viewModel.capability.display)
            }
            
            // Content section
            VStack(alignment: .leading, spacing: 10) {
                
                // Display user prompt
                if !viewModel.userPrompt.isEmpty {
                    Text(Strings.prompt)
                        .font(.headline)
                    ChatBubble(text: viewModel.userPrompt, isUser: true)
                }
                
                // Loading indicator
                if viewModel.isLoading { LoadingView() }
                
                // Display audio response and transcript
                if let audioURL = viewModel.audioURL, !viewModel.transcript.isEmpty {
                    Text(Strings.responseSpeechTranscript)
                        .font(.headline)
                    AudioTranscriptView(audioURL: audioURL, transcript: viewModel.transcript)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            // Input section for new user input
            MessageInputView(userInput: $viewModel.text,
                             isLoading: viewModel.isLoading,
                             placeholder: Strings.placeholderPrompt,
                             onSend: viewModel.sendAudioChatAPI)
        }
        // Title and error handling
        .modifier(title: viewModel.capability.name,
                  showErrorAlert: $viewModel.showErrorAlert,
                  errorMessage: viewModel.errorMessage)
    }
}


#Preview {
    if let firstModel = openAIModels.first {
        if let firstCapability = firstModel.capabilities.first {
            AudioResponseView(capability: firstCapability)
        }
    }
}
