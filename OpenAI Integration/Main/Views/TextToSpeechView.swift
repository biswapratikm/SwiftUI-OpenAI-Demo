//
//  TextToSpeechView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 24/10/24.
//

import SwiftUI
import AVFoundation

struct TextToSpeechView: View {
    
    // ViewModel for Text-to-Speech
    @StateObject var viewModel: TextToSpeechViewModel
    
    // Initialize ViewModel with a capability
    init(capability: Capability) {
        _viewModel = StateObject(wrappedValue: TextToSpeechViewModel(capability: capability))
    }
    
    var body: some View {
        VStack {
            
            // Show instructions if no prompt
            if viewModel.userPrompt.isEmpty {
                InstructionTextView(text: viewModel.capability.display)
            }
            
            // Content section
            VStack(alignment: .leading, spacing: 10) {
                
                // Display user's prompt
                if !viewModel.userPrompt.isEmpty {
                    Text(Strings.prompt).font(.headline)
                    ChatBubble(text: viewModel.userPrompt, isUser: true)
                }
                
                // Loading indicator
                if viewModel.isLoading { LoadingView() }
                
                // Display and play audio
                if let audioURL = viewModel.audioURL {
                    Text(Strings.responseSpeech).font(.headline)
                    AudioPlaybackView(audioURL: audioURL, autoPlay: true)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            // Text Input Section
            MessageInputView(userInput: $viewModel.text,
                             isLoading: viewModel.isLoading,
                             placeholder: Strings.placeholderPrompt,
                             onSend: viewModel.sendTextToSpeechAPI)
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
            TextToSpeechView(capability: firstCapability)
        }
    }
}
