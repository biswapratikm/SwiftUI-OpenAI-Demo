//
//  ImageManipulationView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 24/10/24.
//

import SwiftUI

struct ImageVariationView: View {
    
    // ViewModel for Image Variation
    @StateObject private var viewModel: ImageVariationViewModel
    
    // Initialize ViewModel with capability
    init(capability: Capability) {
        _viewModel = StateObject(wrappedValue: ImageVariationViewModel(capability: capability))
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
                    Text(Strings.selectedImage).font(.headline)
                    ImageView(image: selectedImage)
                        .frame(height: 180)
                }
                
                // Loading indicator
                if viewModel.isLoading { LoadingView() }
                
                // Display generated image variation
                if let generatedImage = viewModel.generatedImage {
                    Text(Strings.generatedVariation).font(.headline)
                    ImageView(image: generatedImage)
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
        // Generate image when selection changes
        .onChange(of: viewModel.selectedImage) {
            if viewModel.selectedImage != nil {
                viewModel.generateImage()
            }
        }
    }
}


#Preview {
    if let firstModel = openAIModels.first {
        if let firstCapability = firstModel.capabilities.first {
            ImageVariationView(capability: firstCapability)
        }
    }
    
}
