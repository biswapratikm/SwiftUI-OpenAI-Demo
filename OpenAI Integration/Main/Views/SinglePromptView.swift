//
//  ActionView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 03/10/24.
//

import SwiftUI

struct SinglePromptView: View {
    
    // ViewModel for Single Prompt
    @StateObject private var viewModel: SinglePromptViewModel
    
    // Initialize ViewModel with capability
    init(capability: Capability) {
        _viewModel = StateObject(wrappedValue: SinglePromptViewModel(capability: capability))
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
                    Text(Strings.prompt).font(.headline)
                    ChatBubble(text: viewModel.userPrompt, isUser: true)
                }
                
                // Loading indicator
                if viewModel.isLoading { LoadingView() }
                
                // Display response text
                if !viewModel.result.isEmpty {
                    Text(Strings.responseText).font(.headline)
                    ChatBubble(text: viewModel.result, isUser: false)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            // Text Input Section
            MessageInputView(userInput: $viewModel.userInput,
                             isLoading: viewModel.isLoading,
                             placeholder: Strings.placeholderPrompt,
                             onSend: viewModel.sendRequest)
        }
        // Title, error handling, and toolbar configuration
        .modifier(
            title: viewModel.capability.name,
            showErrorAlert: $viewModel.showErrorAlert,
            errorMessage: viewModel.errorMessage,
            toolbarText: Strings.settings,
            toolbarDestination: SettingsView()
        )
    }
}


#Preview {
    if let firstModel = openAIModels.first {
        if let firstCapability = firstModel.capabilities.first {
            SinglePromptView(capability: firstCapability)
        }
    }
}
