//
//  ImageGenerationView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 24/10/24.
//


import SwiftUI

struct ImageGenerationView: View {
    
    // ViewModel for Image Generation
    @StateObject private var viewModel: ImageGenerationViewModel
    
    // Initialize ViewModel with capability
    init(capability: Capability) {
        _viewModel = StateObject(wrappedValue: ImageGenerationViewModel(capability: capability))
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
                
                // Display generated image
                if let generatedImage = viewModel.generatedImage {
                    Text(Strings.generatedImage).font(.headline)
                    ImageView(image: generatedImage)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            // Text Input Section
            MessageInputView(userInput: $viewModel.userInput,
                             isLoading: viewModel.isLoading,
                             placeholder: "Describe the image...",
                             onSend: viewModel.generateImage)
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
            ImageGenerationView(capability: firstCapability)
        }
    }
}
