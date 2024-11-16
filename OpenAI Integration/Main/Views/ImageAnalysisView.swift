//
//  ImageAnalysisView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 24/10/24.
//


import SwiftUI

struct ImageAnalysisView: View {
    
    // Capability for image analysis
    @StateObject private var viewModel: ImageAnalysisViewModel
    
    // Initialize ViewModel with capability
    init(capability: Capability) {
        _viewModel = StateObject(wrappedValue: ImageAnalysisViewModel(capability: capability))
    }
    
    var body: some View {
        VStack {
            
            // Instructional text when no image is selected
            if viewModel.selectedImage == nil {
                InstructionTextView(text: viewModel.capability.display)
            }
            
            // Content section
            VStack(alignment: .leading) {
                
                // Display selected image
                if let selectedImage = viewModel.selectedImage {
                    Text(Strings.selectedImage)
                        .font(.headline)
                    ImageView(image: selectedImage)
                        .frame(height: 180)
                }
                
                // Loading indicator
                if viewModel.isLoading { LoadingView() }
                
                // Display analysis result
                if !viewModel.analyzedText.isEmpty {
                    Text(Strings.analysisResult)
                        .font(.headline)
                    ChatBubble(text: viewModel.analyzedText, isUser: false)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            // Image selection section
            ImageSelectionView(selectedImage: $viewModel.selectedImage,
                               isLoading: viewModel.isLoading,
                               viewModel: ImageSelectionViewModel())
        }
        // Title and error handling
        .modifier(title: viewModel.capability.name,
                  showErrorAlert: $viewModel.showErrorAlert,
                  errorMessage: viewModel.errorMessage)
        // Trigger analysis when an image is selected
        .onChange(of: viewModel.selectedImage) {
            if viewModel.selectedImage != nil {
                viewModel.analyzeImage()
            }
        }
    }
}



#Preview {
    if let firstModel = openAIModels.first {
        if let firstCapability = firstModel.capabilities.first {
            ImageAnalysisView(capability: firstCapability)
        }
    }
}
